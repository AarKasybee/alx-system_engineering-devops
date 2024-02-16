#!/usr/bin/python3
import requests
def number_of_subscribers(subreddit)
  """
  This function retrieves the subscriber count for a subreddit using the JSON API.

  Args:
    subreddit: The name of the subreddit to query.

  Returns:
    The number of subscribers for the subreddit, or 0 if an error occurs.
  """
  url = "https://www.reddit.com/r/{}/about.json".format(subreddit)
    headers = {
        "User-Agent": "linux:0x16.api.advanced:v1.0.0 (by /u/bdov_)"
    }
    response = requests.get(url, headers=headers, allow_redirects=False)
    if response.status_code == 404:
        return 0
    results = response.json().get("data")
    return results.get("subscribers")
