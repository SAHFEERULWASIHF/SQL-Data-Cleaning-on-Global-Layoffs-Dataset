# 🧹 Data Cleaning Project - Layoffs Dataset

This project focuses on cleaning a dataset of company layoffs to prepare it for further **Exploratory Data Analysis (EDA)**.  
The data cleaning was performed entirely in **SQL (MySQL)**.

---

## 📌 Project Overview

The raw `layoffs.csv` dataset contains inconsistencies such as:
- Duplicate rows
- Extra spaces in text fields
- Inconsistent industry and country naming
- Invalid or empty date formats
- Null values in certain columns

Through systematic SQL transformations, these issues were resolved and a **clean dataset** was produced:  
👉 `cleaned_data/clean_data_layoffs.csv`

---

## ⚙️ Steps in Data Cleaning

1. **Remove Duplicates**
   - Created a distinct table `layoffs_duplicate2`.

2. **Standardize Data**
   - Trimmed whitespace from company names.
   - Unified industry names (e.g., `cryptoCurrency` → `Crypto`).
   - Standardized country names (`United States.` → `United States`).
   - Converted `date` column into proper `DATE` format.

3. **Handle Null Values**
   - Replaced blank industry fields with `NULL`.
   - Used `JOIN` logic to populate missing industries where possible.
   - Deleted rows with both `total_laid_off` and `percentage_laid_off` as NULL.

4. **Final Output**
   - Exported the cleaned dataset into `cleaned_data/clean_data_layoffs.csv`.

---

## 📂 Repository Structure
```
Data-Cleaning-Layoffs-Project/
│── README.md
│── Data_Cleaning_Project_using_layoffs_data.sql
│
├── data/
│   ├── layoffs.csv # Raw dataset
│   └── cleaned_data/
│       └── clean_data_layoffs.csv # Final cleaned dataset
│
├── images/
│   ├── before_cleaning.png
│   └── after_cleaning.png
```
---

## 🖼️ Before vs After Cleaning

| Before Cleaning | After Cleaning |
|-----------------|----------------|
| ![Before Cleaning](images/before_cleaning.png) | ![After Cleaning](images/after_cleaning.png) |

---

## 🚀 How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/SAHFEERULWASIHF/SQL-Data-Cleaning-on-Global-Layoffs-Dataset.git
   cd Data-Cleaning-Layoffs-Project
2. Load the SQL script:
   ```sql
   source Data_Cleaning_Project_using_layoffs_data.sql;
3. Access the cleaned data from:
    ```bash
    data/cleaned_data/clean_data_layoffs.csv
    ```
## 🛠️ Tools & Technologies

SQL (MySQL)

CSV Data

## 📊 Future Work

Perform EDA on the cleaned dataset.

Create visual dashboards (Power BI / Tableau).

Apply predictive analytics on layoff trends.

## ✨ Author

**F SAHFEERUL WASIHF**  

- 🎓 Graduate (Fresher)  
- 📊 Interested in Data Analytics, Software Development, and Data Cleaning  
- 🛠️ Skills: SQL, Python, Data Visualization, Data Wrangling  
- 🔗 [GitHub](https://github.com/SAHFEERULWASIHF) | [LinkedIn](https://www.linkedin.com/in/sahfeerul-wasihf) | [Portfolio](https://sider.ai/agents/web-creator/share/687dafb1877a7836b019027f)  
- 📧 Contact: wasihfwork@gmail.com

