<h1>Incident Postmortem for a Self-service internet cafe</h1>

<h2>Brief background</h2>
<p>A small internet cafe is designed to be self-serving to its customers. Customers can go to the internet cafe and connect to the Wi-Fi network of the internet cafe. The internet cafe is run on a network of interconnected routers to provide fast internet. When a customer connects, the system will prompt open a web page on their laptop or smartphone where they will define a session, duration of that session and will be prompted to make a payment before they can start using the internet. A possible incident would be a traffic overload that leads to a disruption in service, thus causing user/client frustration. Here is a postmortem of such an incident.</p>

<h3><b>Postmortem</b></h3>

<p>
<b>Issue Summary: Unforeseen surge in user traffic leading to Wi-Fi network overload and service disruption.</b>
<ul>
<li>Duration: 10 minutes</li>
<li>Start time: 10:30am CAT</li>
<li>End time: 10:40am CAT</li>
<li>Impact: Loss of internet service for all users leading to User frustration, lost revenue, and potential damage to the café's reputation</li>
<li>Root cause: Surge in internet user traffic due to a newly launched online game overloaded the router capacities causing a network infrastructure failure.</li>
</ul>
</p>

<h3><b>Timeline</b></h3>
<p>
<ul>
<li>The issue was detected at 10:31am CAT</li>
<li>I was the on-call engineer and Ireceived an SMS alert on my phone from the pagerduty system and confirmation of the system being down was received from our clients in form of complaints</li>
<li>The  issue was automatically detected by datadog which has been configured to monitor network metrics such as bandwidth usage, CPU/memory load on routers, and access point status.</li>
<li>The first action I took was to reassure the customers that we were aware of the problem and that we were working on it to restore service as soon as possible.</li>
<li>Then I went straight to check if the Wi-Fi routers were down or if the internet network from the internet service provider (ISP) was down.</li>
<li>Some assumptions of the cause was a possible power failure, ISP network failure, malfunctioning Wi-Fi router, and user traffic overload.</li>
<li>I further opened the log files which show detailed information of the failure including the exact time frame and duration of the failure.</li>
<li>I resolved the issue by powering down the whole system for 3 minutes as I added 3 more backup routers as a quick fix to the problem in the meantime and restored service to the clients.</li>
<li>To prevent this from happening again, I brainstormed possible solutions such as load balancing and redundancy,  internet bandwidth upgrades, regular stress testing and optimisation, and considered offering different service plans with different bandwidths.</li>
</ul>
</p>

<h3>Root cause and Resolution</h3>
<p>
The cafe is served by routers to provide internet to its users and each router has a maximum number of users that it can handle. There are also some redundant routers to help with load balancing. However, on this day, the cafe received more users than anticipated such that even the redundancy of the extra routers was insufficient. This led to a network overload and failing of the whole system.
This issue was resolved by adding some more routers to the network as a way to handle the increased demand.
</p>

<h3>Corrective and preventative measures</h3>
<p>
To prevent this from happening again, I looked int the following possible solutions.
<ul>
<li>Implementing dynamic bandwidth allocation based on user needs and priorities.</li>
<li>Explore technologies like Quality of Service (QoS) to prioritise specific traffic types.</li>
<li>Partner with multiple internet service providers to ensure redundancy and failover options.</li>
<li>Use routers with greater capacities.</li>
</ul>
The general approach to handling ssytem issues and ensuring they never repeat is by following this approach given by www.atlassian.com as shown in the following image.
<img src="https://wac-cdn.atlassian.com/dam/jcr:77b7d90d-6b76-47f2-bc2a-f547f8a3eacb/IMMKT-153-illustration-for-postmortem-page.png?cdnVersion=1450" alt="Service life-cycle" width="500" height="600">
</p>
