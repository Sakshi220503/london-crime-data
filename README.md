# 🔍 London Crime Analysis (April 2023 – March 2026)

An end-to-end data analytics project exploring crime patterns across London boroughs using official Met Police open data. Covers data cleaning, exploratory analysis, SQL querying, machine learning forecasting, and Power BI visualisation.

---

## 📊 Key Findings

- **3.4 million** crime incidents analysed across London between April 2023 and March 2026
- **Violence and Sexual Offences** was the most common crime type throughout the entire period
- **Westminster** recorded the highest total crime volume of any London borough
- **July** was consistently the highest crime month — summer peaks are clearly visible in the data
- Crime volume grew by **+33.2%** from 2023 (856,305) to 2025 (1,140,416), suggesting a significant upward trend across London
- A **Random Forest model** predicted monthly crime volume per borough with an R² of **0.991** and MAE of **36 incidents**
- The single strongest predictor of next month's crime was **rolling 3-month average** — meaning recent trends are the best signal

---

## 🤖 Machine Learning Results

Three models were trained to forecast monthly crime volume per borough:

| Model | MAE | RMSE | R² |
|---|---|---|---|
| Linear Regression | 48.6 | 114.2 | 0.992 |
| Random Forest | 36.1 | 121.3 | 0.991 |
| Gradient Boosting | 35.1 | 111.6 | **0.992** |

- **Gradient Boosting** achieved the best overall balance of MAE and R²
- All three models performed strongly, confirming that crime volume is highly predictable from recent trends
- **Top predictive feature:** `rolling_mean_3` (3-month rolling average of past crime) — meaning the best indicator of future crime is recent crime history

---

## 🛠️ Tools & Skills Demonstrated

| Area | Tools |
|---|---|
| Data wrangling | Python, pandas |
| Visualisation | matplotlib, seaborn |
| SQL analysis | SQLite (via pandas + sqlite3) |
| Machine learning | scikit-learn (Random Forest, Gradient Boosting, Linear Regression) |
| BI Dashboard | Power BI |
| Version control | Git, GitHub |

---

## 📁 Project Structure

```
london-crime-analysis/
│
├── data/
│   ├── raw/                   ← downloaded CSVs from data.police.uk
│   └── processed/             ← cleaned CSV + exported charts
│
├── notebooks/
│   ├── 01_data_cleaning.ipynb ← load, clean and merge raw data
│   ├── 02_eda.ipynb           ← trends, borough, seasonal analysis
│   ├── 03_insights.ipynb      ← SQL queries via SQLite
│   └── 04_ml_model.ipynb      ← crime volume forecasting model
│
├── sql/
│   └── crime_queries.sql      ← 10 business SQL queries
│
├── dashboard/
│   └── london_crime.pbix      ← Power BI dashboard
│
└── README.md
```

---

## 📦 Data Source

**[data.police.uk](https://data.police.uk/data/)** — Official UK Police open data portal.

**How to download:**
1. Go to https://data.police.uk/data/
2. Select **Metropolitan Police Service**
3. Set date range: **April 2023 → March 2026**
4. Click **Generate File** and download the ZIP
5. Unzip all CSV files into `data/raw/`

---

## ▶️ How to Run

```bash
# 1. Clone the repo
git clone https://github.com/Sakshi220503/london-crime-analysis.git
cd london-crime-analysis

# 2. Install dependencies
pip install pandas matplotlib seaborn jupyter scikit-learn

# 3. Download data (see above) into data/raw/

# 4. Run notebooks in order
jupyter notebook
```

Run notebooks in this order:
1. `01_data_cleaning.ipynb` — generates `london_crime_clean.csv`
2. `02_eda.ipynb` — generates charts
3. `03_insights.ipynb` — runs SQL analysis
4. `04_ml_model.ipynb` — trains and evaluates ML models

---

## 📸 Dashboard Preview

*(Add a screenshot of your Power BI dashboard here)*

---

## 💡 Potential Extensions

- Choropleth map by borough using geopandas
- Deploy forecasting model as a simple Streamlit web app
- Correlate crime data with deprivation index or housing prices

---

*Data: © Crown copyright and database right. Contains public sector information licensed under the [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).*

