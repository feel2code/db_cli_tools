import os

import yaml


def dbt_schema_yml_splitter():
    """
    Splits the schema.yml file of DBT schema to multiple schema YML files by models
    """
    try:
        with open("schema.yml", "r", encoding="utf-8") as stream:
            data = yaml.load(stream, yaml.FullLoader)
            for model in data["models"]:
                with open(model["name"] + ".yml", "a", encoding="utf-8") as outfile:
                    outfile.write(f"version: {data['version']}\n\nmodels:\n")
                    yaml.dump(
                        data=[model],
                        stream=outfile,
                        default_flow_style=False,
                        sort_keys=False,
                        allow_unicode=True,
                        encoding="utf-8",
                    )
    except yaml.YAMLError as e:
        print(e)


def dbt_schema_merge():
    """
    Merges the schemas in current directory to one schema.yml file
    """
    base_data = []
    for source in [x for x in os.listdir() if x[-3:] == "yml"]:
        with open(source, "r", encoding="utf-8") as data_source:
            data = yaml.load(data_source, yaml.FullLoader)
            models = data["models"][0]
            base_data.append(models)

    with open("schema.yml", "w", encoding="utf-8") as yaml_output:
        yaml_output.write(f"version: {data['version']}\n\nmodels:\n")
        yaml.dump(
            data=base_data,
            stream=yaml_output,
            default_flow_style=False,
            sort_keys=False,
            allow_unicode=True,
            encoding="utf-8",
        )


if __name__ == "__main__":
    inp = input("Split(1) or Merge(2)?")
    if inp == 1:
        dbt_schema_yml_splitter()
    elif inp == 2:
        dbt_schema_merge()
    else:
        print("Out of value. Please select 1 or 2 next time.")
