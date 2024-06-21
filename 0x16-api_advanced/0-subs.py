#!/usr/bin/python3
"""Function that queries the Reddit API and returns the number of subscribers"""
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
        try:
            results = response.json().get("data", {})
            return results.get("subscribers", 0)
        except ValueError:
            print(f"Error decoding JSON for subreddit: {subreddit}")
            return 0
    except requests.RequestException as e:
        print(f"Request error: {e}")
        return 0
