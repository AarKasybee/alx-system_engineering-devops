#!/usr/bin/python3
"""function that queries Reddit API and returns the number of subscribers"""
import requests

def number_of_subscribers(subreddit):
    """Return the total number of subscribers on a given subreddit."""
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {
        'User-Agent': "linux:0x16.api.advanced:v1 (by /u/muntuwanga)"
    }
    try:
        response = requests.get(url, headers=headers, allow_redirects=False)
        if response.status_code == 404:
            return 0
        if response.status_code != 200:
            return 0
        results = response.json().get("data", {})
        return results.get("subscribers", 0)
    except Exception:
        return 0
