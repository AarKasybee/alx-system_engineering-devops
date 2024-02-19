Incident Postmortem for a Self-service internet cafe

Brief background
A small internet cafe is designed to be self-serving to its customers. Customers can go to the internet cafe and connect to the Wi-Fi network of the internet cafe. The internet cafe is run on a network of interconnected routers to provide fast internet. When a customer connects, the system will prompt open a web page on their laptop or smartphone where they will define a session, duration of that session and will be prompted to make a payment before they can start using the internet. A possible incident would be a traffic overload that leads to a disruption in service, thus causing user/client frustration. Here is a postmortem of such an incident.

Postmortem

Issue Summary: Unforeseen surge in user traffic leading to Wi-Fi network overload and service disruption.
•	Duration: 10 minutes
•	Start time: 10:30am CAT
•	End time: 10:40am CAT
•	Impact: Loss of internet service for all users leading to User frustration, lost revenue, and potential damage to the café's reputation
•	Root cause: Surge in internet user traffic due to a newly launched online game overloaded the router capacities causing a network infrastructure failure.

Timeline
•	The issue was detected at 10:31am CAT
•	I was the on-call engineer and Ireceived an SMS alert on my phone from the pagerduty system and confirmation of the system being down was received from our clients in form of complaints
•	The  issue was automatically detected by datadog which has been configured to monitor network metrics such as bandwidth usage, CPU/memory load on routers, and access point status.
•	The first action I took was to reassure the customers that we were aware of the problem and that we were working on it to restore service as soon as possible.
•	Then I went straight to check if the Wi-Fi routers were down or if the internet network from the internet service provider (ISP) was down.
•	Some assumptions of the cause was a possible power failure, ISP network failure, malfunctioning Wi-Fi router, and user traffic overload.
•	I further opened the log files which show detailed information of the failure including the exact time frame and duration of the failure.
•	I resolved the issue by powering down the whole system for 3 minutes as I added 3 more backup routers as a quick fix to the problem in the meantime and restored service to the clients.
•	To prevent this from happening again, I brainstormed possible solutions such as load balancing and redundancy,  internet bandwidth upgrades, regular stress testing and optimisation, and considered offering different service plans with different bandwidths.
Root cause and Resolution
The cafe is served by routers to provide internet to its users and each router has a maximum number of users that it can handle. There are also some redundant routers to help with load balancing. However, on this day, the cafe received more users than anticipated such that even the redundancy of the extra routers was insufficient. This led to a network overload and failing of the whole system.
This issue was resolved by adding some more routers to the network as a way to handle the increased demand.

Corrective and preventative measures
To prevent this from happening again, I looked int the following possible solutions.
•	Implementing dynamic bandwidth allocation based on user needs and priorities.
•	Explore technologies like Quality of Service (QoS) to prioritise specific traffic types.
•	Partner with multiple internet service providers to ensure redundancy and failover options.
•	Use routers with greater capacities.


