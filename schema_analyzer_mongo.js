// Set your collection name
const collectionName = "collection"; // Replace with your collection name

// Sample 1000 documents (or adjust this number based on your data size)
const sampleSize = 100000;

// Step 1: Count the total number of documents
const countOfDocuments = db.getCollection(collectionName).countDocuments();

// Step 2: Use aggregation to analyze field types
const schema = db.getCollection(collectionName).aggregate([
  { $sample: { size: sampleSize } }, // Sample documents to get field types
  {
    $project: {
      fields: { $objectToArray: "$$ROOT" } // Convert each document into an array of key-value pairs
    }
  },
  { $unwind: "$fields" },
  {
    $group: {
      _id: "$fields.k", // Group by field name
      types: { $addToSet: { $type: "$fields.v" } } // Gather field types
    }
  },
  {
    $project: {
      field: "$_id",
      types: 1,
      _id: 0
    }
  },
  { $sort: { field: 1 } } // Sort fields alphabetically
]).toArray();

// Format the schema output as required
const formattedSchema = {
  count_of_documents: countOfDocuments,
  fields: schema.map(field => ({
    name: field.field,
    types: field.types
  }))
};

printjson(formattedSchema);
