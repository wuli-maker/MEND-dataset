import pandas as pd
import json


def dta_to_json(dta_file, json_file):
    # Read the .dta file
    reader = pd.io.stata.StataReader(dta_file, convert_categoricals=False)
    data = reader.read() 
    value_labels = reader.value_labels() 

    # Create mapping between column names and label dictionaries
    label_mapping = {
        # Basic information such as gender, ethnicity, birthplace
        "sex": "sex_lbl",  # Gender
        "ethnic": "ethnic_lbl",  # Ethnicity
        "birth_place": "birth_place_lbl",  # Birthplace

        # Marital status
        "marital_08": "marital_lbl",  # Marital status in 2008
        "marital_11": "marital_lbl",  # Marital status in 2011
        "marital_14": "marital_lbl",  # Marital status in 2014
        "marital_18": "marital_lbl",  # Marital status in 2018

        # Economic status
        "econ_state_08": "econ_state_lbl",  # Economic status in 2008
        "econ_state_11": "econ_state_lbl",  # Economic status in 2011
        "econ_state_14": "econ_state_lbl",  # Economic status in 2014
        "econ_state_18": "econ_state_lbl",  # Economic status in 2018

        # Smoking status
        "smoke_08": "smoke_lbl",  # Smoking status in 2008
        "smoke_11": "smoke_lbl",  # Smoking status in 2011
        "smoke_14": "smoke_lbl",  # Smoking status in 2014
        "smoke_18": "smoke_lbl",  # Smoking status in 2018

        # Drinking status
        "drink_08": "drink_lbl",  # Drinking status in 2008
        "drink_11": "drink_lbl",  # Drinking status in 2011
        "drink_14": "drink_lbl",  # Drinking status in 2014
        "drink_18": "drink_lbl",  # Drinking status in 2018

        # Exercise status
        "exercise_08": "exercise_lbl",  # Exercise status in 2008
        "exercise_11": "exercise_lbl",  # Exercise status in 2011
        "exercise_14": "exercise_lbl",  # Exercise status in 2014
        "exercise_18": "exercise_lbl",  # Exercise status in 2018

        # Mortality status
        "dth08_11": "dth08_11_lbl",  # Death between 2008-2011
        "dth11_14": "dth11_14_lbl",  # Death between 2011-2014
        "dth14_18": "dth14_18_lbl",  # Death between 2014-2018

        # Co-residence status
        "co_residence_08": "co_residence_lbl",  # Co-residence in 2008
        "co_residence_11": "co_residence_lbl",  # Co-residence in 2011
        "co_residence_14": "co_residence_lbl",  # Co-residence in 2014
        "co_residence_18": "co_residence_lbl",  # Co-residence in 2018

        # Medical insurance
        "nrcm_11": "nrcm_lbl",  # NRCM in 2011
        "nrcm_14": "nrcm_lbl_14",  # NRCM in 2014
        "nrcm_18": "nrcm_lbl_18",  # NRCM in 2018
        "uebmi_11": "uebmi_lbl",  # UEBMI in 2011
        "uebmi_14": "uebmi_lbl_14",  # UEBMI in 2014
        "urbmi_11": "urbmi_lbl",  # URBMI in 2011
        "urbmi_14": "urbmi_lbl",  # URBMI in 2014
        "basic_medical_insur_08": "insur_lbl",  # Basic medical insurance in 2008

        # Cognitive function, daily living ability, depression symptoms
        "cesd_d": "cesd_lbl",  # Depression symptoms
        "adl_d_08": "adl_lbl",  # ADL in 2008
        "adl_d_11": "adl_lbl",  # ADL in 2011
        "adl_d_14": "adl_lbl",  # ADL in 2014
        "adl_d_18": "adl_lbl",  # ADL in 2018
        "mmse_d_08": "mmse_lbl",  # Cognitive function in 2008
        "mmse_d_11": "mmse_lbl",  # Cognitive function in 2011
        "mmse_d_14": "mmse_lbl",  # Cognitive function in 2014
        "mmse_d_18": "mmse_lbl",  # Cognitive function in 2018
    }

    # Iterate over columns and apply label mapping
    for column, label_key in label_mapping.items():
        if column in data.columns and label_key in value_labels:
            # Replace values with corresponding labels
            data[column] = data[column].map(value_labels[label_key]).fillna(data[column])

    # Save to .json file
    data.to_json(json_file, orient="records", force_ascii=False, indent=4)


def filter_year_18(json_file):
    # Load data
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Define basic information fields and keywords to retain
    basic_fields = {"id", "sex", "ethnic", "birth_place", "cesd", "cesd_d"}  # Basic info fields
    keep_keywords = ["18"]  # Keep fields related to 2018

    # Process data
    filtered_data = []
    for record in data:
        new_record = {}
        for key, value in record.items():
            # Determine whether to retain field
            if key in basic_fields or any(keyword in key for keyword in keep_keywords) or record.keys() == 1:
                new_record[key] = value

        # Ensure "cesd_d" is not null
        if new_record.get("cesd") is not None:
            if new_record.get("adl_18") is not None:
                if new_record.get("mmse_18") is not None:
                    filtered_data.append(new_record)

    # Save results to new JSON file
    with open(json_file, "w", encoding="utf-8") as f:
        json.dump(filtered_data, f, ensure_ascii=False, indent=4)


def main():
    dta_file = "./utils/CLHLS/clhls08_18.dta"
    json_file = "./utils/CLHLS/clhls18_filtered.json"

    # Convert dta to json
    dta_to_json(dta_file, json_file)
    filter_year_18(json_file)


if __name__ == '__main__':
    main()
