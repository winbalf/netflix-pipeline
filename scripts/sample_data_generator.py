"""
Generate sample Netflix data for testing
"""
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import uuid

def generate_netflix_titles(n=10000):
    """Generate sample Netflix titles data"""
    types = ['Movie', 'TV Show']
    ratings = ['TV-Y', 'TV-Y7', 'TV-G', 'TV-PG', 'TV-14', 'TV-MA', 'G', 'PG', 'PG-13', 'R', 'NC-17']
    countries = ['United States', 'India', 'United Kingdom', 'Canada', 'France', 'Germany', 'Japan', 'South Korea']
    genres_list = [
        'Action', 'Adventure', 'Anime', 'Comedy', 'Crime', 'Documentary',
        'Drama', 'Fantasy', 'Horror', 'International', 'Kids', 'Romance',
        'Sci-Fi', 'Sports', 'Thriller', 'Western'
    ]
    
    data = []
    for i in range(n):
        show_id = f"s{i+1}"
        type_ = random.choice(types)
        title = f"Sample {type_} {i+1}"
        director = f"Director {random.randint(1, 100)}" if random.random() > 0.3 else None
        cast = ", ".join([f"Actor {j}" for j in range(random.randint(1, 5))])
        country = random.choice(countries)
        date_added = (datetime.now() - timedelta(days=random.randint(0, 365*3))).strftime('%B %d, %Y')
        release_year = random.randint(1990, 2024)
        rating = random.choice(ratings)
        duration = f"{random.randint(60, 180)} min" if type_ == 'Movie' else f"{random.randint(1, 10)} Seasons"
        genres = ", ".join(random.sample(genres_list, random.randint(1, 3)))
        description = f"This is a sample description for {title}"
        
        data.append({
            'show_id': show_id,
            'type': type_,
            'title': title,
            'director': director,
            'cast': cast,
            'country': country,
            'date_added': date_added,
            'release_year': release_year,
            'rating': rating,
            'duration': duration,
            'listed_in': genres,
            'description': description
        })
    
    return pd.DataFrame(data)

def generate_netflix_ratings(n=5000, num_users=500, num_titles=1000):
    """Generate sample ratings data"""
    data = []
    for i in range(n):
        rating_id = str(uuid.uuid4())
        user_id = f"user_{random.randint(1, num_users)}"
        title_id = f"s{random.randint(1, num_titles)}"
        rating = round(random.uniform(1.0, 5.0), 2)
        rating_date = datetime.now() - timedelta(days=random.randint(0, 365))
        review_text = f"Sample review text {i}" if random.random() > 0.5 else None
        
        data.append({
            'rating_id': rating_id,
            'user_id': user_id,
            'title_id': title_id,
            'rating': rating,
            'rating_date': rating_date.strftime('%Y-%m-%d'),
            'review_text': review_text
        })
    
    return pd.DataFrame(data)

def generate_viewing_history(n=10000, num_users=500, num_titles=1000):
    """Generate sample viewing history data"""
    devices = ['Mobile', 'Tablet', 'TV', 'Desktop', 'Smart TV']
    
    data = []
    for i in range(n):
        viewing_id = str(uuid.uuid4())
        user_id = f"user_{random.randint(1, num_users)}"
        title_id = f"s{random.randint(1, num_titles)}"
        watch_date = datetime.now() - timedelta(
            days=random.randint(0, 365),
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59)
        )
        watch_duration_minutes = random.randint(5, 180)
        completion_percentage = round(random.uniform(0, 100), 2)
        device_type = random.choice(devices)
        
        data.append({
            'viewing_id': viewing_id,
            'user_id': user_id,
            'title_id': title_id,
            'watch_date': watch_date.strftime('%Y-%m-%d %H:%M:%S'),
            'watch_duration_minutes': watch_duration_minutes,
            'completion_percentage': completion_percentage,
            'device_type': device_type
        })
    
    return pd.DataFrame(data)

if __name__ == "__main__":
    # Generate sample data
    print("Generating sample Netflix titles...")
    titles_df = generate_netflix_titles(1000)
    titles_df.to_csv('data/netflix_titles.csv', index=False)
    print(f"Generated {len(titles_df)} titles")
    
    print("Generating sample ratings...")
    ratings_df = generate_netflix_ratings(5000, 500, 1000)
    ratings_df.to_csv('data/netflix_ratings.csv', index=False)
    print(f"Generated {len(ratings_df)} ratings")
    
    print("Generating sample viewing history...")
    viewing_df = generate_viewing_history(10000, 500, 1000)
    viewing_df.to_csv('data/netflix_viewing_history.csv', index=False)
    print(f"Generated {len(viewing_df)} viewing records")
    
    print("\nSample data generated successfully!")
    print("Files saved in 'data/' directory")


