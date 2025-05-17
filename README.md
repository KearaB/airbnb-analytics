# 🏠 Airbnb Analytics

> 🚧 **Under Construction**  
This project is currently in progress — updates will be made regularly as the pipeline and models evolve. Stay tuned! ✨

---

## 📚 Table of Contents

- [🎯 Project Intention](#-project-intention)
- [⚙️ Tech Stack](#️-tech-stack)
- [🧩 Planned Features](#-planned-features)
- [📥 Data Loading & Preprocessing (Notebook)](#-data-loading--preprocessing-notebook)
- [💡 Inspiration](#-inspiration)
- [📬 Stay Updated](#-stay-updated)

---

## 🎯 Project Intention

This is an analytics engineering portfolio project using open-source Airbnb data from various global cities. 🌍

The goal is to:
- 🧼 **Ingest, clean, and standardize** Airbnb listing data across multiple locations.
- 🧠 **Model the data** using dbt to enable meaningful insights on listings, hosts, and trends.
- 📊 **Build dashboards** using Looker Studio to visualize performance and patterns.
- 🧪 Showcase **Analytics Engineering best practices** using a modern data stack.

---

## ⚙️ Tech Stack

| Layer              | Tool                          |
|-------------------|-------------------------------|
| 🐍 Ingestion & Prep | Python (pandas, Jupyter)       |
| ☁️ Data Warehouse   | Google BigQuery (Sandbox)     |
| 🧱 Modeling         | dbt Cloud (Free Tier)          |
| 📊 Reporting        | Looker Studio                 |
| 🗃 Version Control   | Git & GitHub                  |

---

## 🧩 Planned Features

- 📥 Multi-source data ingestion (city-based CSVs.)
- 🧹 Data cleaning, type casting, and appending with Python.
- 🏗 Modular dbt models (staging, fact, dimension, and mart layers.)
- 📈 Interactive Looker Studio dashboard powered by BigQuery.
- 🧪 End-to-end analytics engineering workflow. 

---

## 📥 Data Loading & Preprocessing (Notebook)

The following steps were implemented in a Jupyter Notebook to ingest and clean the data before loading it to BigQuery:

Ensure you've installed the following packages:
```bash
pip install pandas numpy pandas-gbq
```

**Note:** Below is the folder structure used for the Python-based data loading and preprocessing steps.
```
airbnb-analytics/
├── credentials/
│   └── service_account.json
│
├── data_source/
│   ├── athens/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── berlin/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── cape_town/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── edinburgh/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── lisbon/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── london/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── madrid/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── milan/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   ├── quebec/
│   │   ├── calendar.csv.gz
│   │   ├── listings.csv.gz
│   │   ├── neighbourhoods.csv
│   │   └── reviews.csv.gz
│   └── stockholm/
│       ├── calendar.csv.gz
│       ├── listings.csv.gz
│       ├── neighbourhoods.csv
│       └── reviews.csv.gz
|
└── loader.ipynb
```


### Configs
---
```python
# Imports
import pandas as pd
import os
import uuid
from pandas_gbq import to_gbq
import numpy as np

# Display Configs
pd.set_option('display.max_columns', None)
```


## Load Source Data
---
```python
# Define the base folder containing all city subfolders
base_folder = "data_source"

# Expected files and how they should be named in memory
file_map = {
    "calendar.csv.gz": "calendar",
    "listings.csv.gz": "listings",
    "neighbourhoods.csv": "neighbourhoods",
    "reviews.csv.gz": "reviews"
}

# Initialize structure to hold dataframes per type across all cities
all_data = {
    "calendar": [],
    "listings": [],
    "neighbourhoods": [],
    "reviews": []
}
```

```python
# Loop over each city folder in data_source
for city in os.listdir(base_folder):
    city_path = os.path.join(base_folder, city)
    
    # Proceed only if it's a directory
    if os.path.isdir(city_path):
        for filename, label in file_map.items():
            file_path = os.path.join(city_path, filename)
            
            # Load the file if it exists
            if os.path.exists(file_path):
                df = pd.read_csv(file_path, low_memory=False)
                
                # Add city name column
                df['city_name'] = city.title()

                # Add unique ID columns if needed
                if label == "neighbourhoods":
                    # Generate a unique ID per row using UUIDs
                    df['id'] = [str(uuid.uuid4()) for _ in range(len(df))]
                elif label == "calendar":
                    # Generate unique calendar_id per row
                    df['id'] = [str(uuid.uuid4()) for _ in range(len(df))]

                # Store in the master list for that file type
                all_data[label].append(df)
```

### Transformation
---

```python
# Combine each type into one single DataFrame across all cities
calendars = pd.concat(all_data["calendar"], ignore_index=True)
listings = pd.concat(all_data["listings"], ignore_index=True)
neighbourhoods = pd.concat(all_data["neighbourhoods"], ignore_index=True)
reviews = pd.concat(all_data["reviews"], ignore_index=True)
```

```python
# List of fields to drop from listings
columns_to_drop = [
    'host_thumbnail_url',
    'host_picture_url',
    'number_of_reviews',
    'number_of_reviews_ltm',
    'number_of_reviews_l30d',
    'number_of_reviews_ly',
    'estimated_occupancy_l365d',
    'reviews_per_month',
    'calculated_host_listings_count',
    'calculated_host_listings_count_entire_homes',
    'calculated_host_listings_count_private_rooms',
    'calculated_host_listings_count_shared_rooms',
    'scrape_id',
    'host_listings_count',
    'host_total_listings_count',
    'host_identity_verified',
    'minimum_minimum_nights',
    'maximum_minimum_nights',
    'minimum_maximum_nights',
    'maximum_maximum_nights',
    'minimum_nights_avg_ntm',
    'maximum_nights_avg_ntm',
    'calendar_updated',
    'availability_30',
    'availability_60',
    'availability_90',
    'availability_365',
    'availability_eoy',
    'first_review',
    'last_review',
    'calendar_last_scraped'
]

# Drop them from the listings DataFrame
listings = listings.drop(columns=columns_to_drop, errors='ignore')
```

```python
# ✅ Preview combined DataFrames
print("Combined Calendars:", calendars.shape)
print("Combined Listings:", listings.shape)
print("Combined Neighbourhoods:", neighbourhoods.shape)
print("Combined Reviews:", reviews.shape)
```


```python
# Reprocessing boolean fields
calendar_booleans = ['available']
for field in calendar_booleans:
  calendars[field] = calendars[field].map({'t': True, 'f': False})

listings_booleans = ['host_is_superhost',
                   'host_has_profile_pic',
                   'instant_bookable',
                   'has_availability'
                   ]
for field in listings_booleans:
  listings[field] = listings[field].map({'t': True, 'f': False})

```


```python
# Additional Type Casting
## Calendars
calendars['listing_id'] = calendars['listing_id'].astype(str)
calendars['date'] = pd.to_datetime(calendars['date'])
calendars['minimum_nights'] = calendars['minimum_nights'].astype('Int32') # nullable integer
calendars['maximum_nights'] = calendars['maximum_nights'].astype('Int32') # nullable integer
calendars['available'] = calendars['available'].astype(bool)

## Reviews
reviews['listing_id'] = reviews['listing_id'].astype(str)             
reviews['id'] = reviews['id'].astype(str)                             
reviews['reviewer_id'] = reviews['reviewer_id'].astype(str)
reviews['date'] = pd.to_datetime(reviews['date'])      

## Listings
listings['id'] = listings['id'].astype(str)
listings['last_scraped'] = pd.to_datetime(listings['last_scraped'])
listings['host_id'] = listings['host_id'].astype(str)
listings['host_since'] = pd.to_datetime(listings['host_since'])
listings['latitude'] = listings['latitude'].astype('Float32')
listings['longitude'] = listings['longitude'].astype('Float32')
listings['accommodates'] = listings['accommodates'].astype('Int32')
listings['bathrooms'] = listings['bathrooms'].astype('Float32')
listings['bedrooms'] = listings['bedrooms'].astype('Float32')
listings['beds'] = listings['beds'].astype('Float32')
listings['minimum_nights'] = listings['minimum_nights'].astype('Int32')
listings['maximum_nights'] = listings['maximum_nights'].astype('Int32')
listings['estimated_revenue_l365d'] = listings['estimated_revenue_l365d'].astype('float32')
listings['review_scores_rating'] = listings['review_scores_rating'].astype('float32')
listings['review_scores_accuracy'] = listings['review_scores_accuracy'].astype('float32')
listings['review_scores_cleanliness'] = listings['review_scores_cleanliness'].astype('float32')
listings['review_scores_checkin'] = listings['review_scores_checkin'].astype('float32')
listings['review_scores_communication'] = listings['review_scores_communication'].astype('float32')
listings['review_scores_location'] = listings['review_scores_location'].astype('float32')
listings['review_scores_value'] = listings['review_scores_value'].astype('float32')
```


### Load Data to BigQuery
---

```python
# 🫆 Authenticate
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "credentials/service_account.json"
```

```python
# ⚙️ Config
project_id = "project_id"              # use your project id
dataset = "dataset_name"               # use your dataset name
```

```python
# 🗂️ Map DataFrames directly to table names
dfs = {
    "calendars": calendars,
    "listings": listings,
    "neighbourhoods": neighbourhoods,
    "reviews": reviews
}
```

**👇Incrementally upload data to BigQuert Schema👇**
```python
# Batch Size Conifg
batch_size = 50_000

for table_name, df in dfs.items():
    print(f"⏳ Uploading {table_name} in {batch_size}-row chunks...")

    # Replace the table first using only the first chunk
    first_chunk = df.iloc[:batch_size]
    to_gbq(
        dataframe=first_chunk,
        destination_table=f"{dataset}.{table_name}",
        project_id=project_id,
        if_exists="replace",   # Replace on the first chunk
        chunksize=batch_size
    )

    print(f"✅ Replaced {table_name} with first {batch_size} rows...")

    # Append remaining chunks
    for start in range(batch_size, len(df), batch_size):
        end = start + batch_size
        chunk = df.iloc[start:end]

        to_gbq(
            dataframe=chunk,
            destination_table=f"{dataset}.{table_name}",
            project_id=project_id,
            if_exists="append",  # Append for all remaining chunks
            chunksize=batch_size
        )

        print(f"✅ Appended rows {start} to {min(end, len(df))} of {table_name}")

    print(f"🏁 Finished uploading {table_name}\n")
```

