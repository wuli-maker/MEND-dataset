import json
import os


def information_merge(file_path, protrait_path):
    
    number_list = os.listdir(protrait_path)
    
    with open(file_path, "r", encoding='utf-8') as data_file:
        data = json.load(data_file)

        for i, elderly_client in enumerate(data):
            str_i = str(i).zfill(2)
            if str_i not in number_list:
                continue

            children_number_18 = elderly_client["children_number_18"]
            if children_number_18 is None or children_number_18 == "":
                children_number = "未知"
            else:
                children_number = str(int(children_number_18))
            
            cesd_points = elderly_client["cesd"]
            if cesd_points <= 9:
                cesd = 0
                cesd_d = "无抑郁风险"
            elif 10 <= cesd_points <= 14:
                cesd = 1
                cesd_d = "轻度抑郁风险"
            elif 15 <= cesd_points <= 19:
                cesd = 2
                cesd_d = "中度抑郁风险"
            else:
                cesd = 3
                cesd_d = "重度抑郁风险"
            
            adl = elderly_client["adl_18"]
            adl_d = "日常生活活动能力" + elderly_client["adl_d_18"]
            mmse = elderly_client["mmse_18"]
            mmse_d = elderly_client["mmse_d_18"]

            full_portrait_path = os.path.join(protrait_path, str_i, "full_portrait.json")
            with open(full_portrait_path, "r", encoding="utf-8") as f:
                protrait_data = json.load(f)

            protrait_data["self-portrait"]["basic_information"]["age"] = int(elderly_client["trueage_18"])
            protrait_data["self-portrait"]["basic_information"]["gender"] = elderly_client["sex"]
            protrait_data["self-portrait"]["basic_information"]["martial_status"] = elderly_client["marital_18"]
            protrait_data["self-portrait"]["basic_information"]["economic_status"] = elderly_client["econ_state_18"]
            protrait_data["self-portrait"]["basic_information"]["co_residence"] = elderly_client["co_residence_18"]
            protrait_data["self-portrait"]["basic_information"]["birth_place"] = elderly_client["birth_place"]
            protrait_data["self-portrait"]["basic_information"]["children_number"] = "有"+children_number+"个小孩"
            protrait_data["self-portrait"]["diagnosis"]["symptoms"] = "ADL(0-12分)的测试得分为" + str(int(adl)) + "分，" + adl_d + "；MMSE(0-30分)的测试得分为" + str(int(mmse)) + "分，" + mmse_d
            protrait_data["self-portrait"]["diagnosis"]["status"] = cesd_d
            protrait_data["self-portrait"]["diagnosis"]["drisk"] = cesd

            with open(full_portrait_path, 'w', encoding='utf-8') as f:
                json.dump(protrait_data, f, ensure_ascii=False, indent=4)