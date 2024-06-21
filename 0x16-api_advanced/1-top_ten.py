#!/usr/bin/python3
"""
Function that queries the Reddit API and prints the titles of the
first 10 hot posts listed for a given subreddit.
"""

import requests


def top_ten(subreddit):
    """
    Print the titles of the 10 hottest posts on a given subreddit.

    Args:
        subreddit (str): The name of the subreddit to query.
    """
    url = f"https://www.reddit.com/r/{subreddit}/hot/.json"
    headers = {
        "User-Agent": "python:subreddit.top.ten:v1.0.0 (by /u/yourusername)"
    }
    params = {
        "limit": 10
    }

    try:
        response = requests.get(url, headers=headers, params=params, allow_redirects=False)
        
        if response.status_code == 200:
            if response.headers.get('Content-Type') == 'application/json; charset=UTF-8':
                results = response.json().get("data", {}).get("children", [])
                if results:
                    for post in results:
                        print(post.get("data", {}).get("title"))
                else:
                    print("None")
            else:
                print("None")
        else:
            print("None")
    except requests.RequestException as e:
        print("None")
