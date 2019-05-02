---
date: 2019-05-01T00:00:00+00:00
title: Rely On Smart Processes
description: This post is about how relying on people to follow a process reliably is a fools errand because of the fact that people make mistakes. If we want to engineer failure resistent systems, we need to focus on designing processes to do our work, and not just the work itself.
tags:
  - engineering process
weight: -210
---

As a person who is part of both a pager rotation for production issues at his job, as well as a fast paced product development cycle, I've come to realize that falling back on intelligence and improvisational skills is a reliable way to come up with shortsighted solutions and error-prone systems. The effect becomes compounded considerably when factoring in conditions such as overwork and sleep deprivation. Very few people are capable of making highly technical decisions within complex systems when answering a pager at 03:00 AM.

> We don't rise to the level of our expectations, we fall to the level of our training. - Archilochus

I like this quote a lot. It fits in the domain of maintaining production systems in that, if you get a page about a downed production system, you should already understand said system well enough to know where to look for failure points, _as well_ as what remediation steps are necessary to fix the issue. The system should be designed to be fault tolerant. But dealing with the inevitable production issues should be documented, understood, and, if not engineered away, have an effective and tested disaster recovery plan.

The quote is often misattributed to the American military. But that is not without good reason. Without intending to glorify it, militaries are probably humanities most effective attempts at organizing large groups of people and getting them to participate in a collective, single-minded system. The reason militaries train people with such intensity and repetition is because precisely what this quote says. Under pressure, people no longer have time to think. We need them to be able to make correct decisions without needing to think.

As software engineers, we need to move away from the thought process of only working towards developing features. We also want to deliver those features at scale, with high availability, and at the cheapest price possible. So, when designing a system, it is not enough to simply make apps and connect them to their dependencies, with unit tests that check for feature functionality. It is important for the app to be able to gracefully handle the inevitable failure scenarios that will come up when put to the test in production.

An example would be a simple database in a basic LAMP stack website. It is a simple proposition to make any old CRUD app work using these technologies. But if the MariaDB database goes down, the application is effectively down because of no potential failback. If the application itself starts running into performance problems, the application can become effectively unusable, and there is often no remediation possible without interruption because it is the single point at which users interact with the system. While this is obviously a contrived situation, no-one builds a LAMP stack on a single server anymore in production, the idea of single points of failure and impossible-to-handle situations comes up in a myriad of ways in the real world. But cumulative small design decisions can add up to an enormous reliability impact to the end application.

So to continue the LAMP analogy. One could attempt to cluster the backend database of the application so that if a database crashes, there is an automated fallback. And the application can make use of this change to retry failed connections to the primary database against the second database. Or the Apache webserver loadbalancing logic infront of the application could be moved to a cloud based loadbalancer which is itself a highly available solution. Or (god help ye) you can set up a heartbeat between two Apache webservers acting as loadbalancers infront of your application which will modify a DNS A record to point to the other loadbalancer in the case of a failure.

It's not that difficult to come up with highly available solutions when initially designing a system, when given the time to reason about the problem you are trying to solve. But the mentality cannot stop at simply the design and implementation phase of the project. We all know that maintenance and continuous improvement of the product is the bulk of the work in a software project. Even if it will never be as glorified.

After the system is designed, there must also be efforts towards monitoring the application, and any dependency that the application relies on to perform well and function.

After monitoring has been put into place, a decision must be made on how to alert on system degredation and system failure scenarios.

When alerting rules are being written, the alerts must be descriptive so that the poor engineer who must respond to them will not have to spend time figuring out what the problem actually is, and where to further investigate for a root cause. You can even link to a runbook in the alert for instructions on how to deal with said alert.

Finally, when the alerts have been defined. The engineer must be trained to know how to use the monitoring program to understand where the system is misbehaving, how to drill down to more fine grained metrics, determine the root cause, and resolve it.

When all is said and done, the system cannot be considered production ready until extensive effort has been made into identifying and dealing with failure scenarios. The exercise of defining alerts and learning how to resolve them can also reveal ways to simply engineer the problem out of the system, or automated ways for the system to self-heal after running into issues. Going through all of this effort is worth it, so that when production really is down and the lost revenue counter starts rising, an engineer does not need to be brilliant on the spot. They can trust in the software system they have to built to either handle itself, or they can trust in the predefined contingency plan to carry them through the day.

When the response to a page is to first try to find logs, then perhaps a dashboard, then probably an internet web search, not only is the time to fix drastically increased, but the quality of the fix is likely going to be sub-par.

Once a sub-par solution has been put into a system, it can quickly lead to compounding effects that further and further compromise the quality of said system. Let's pretend that we get a generic alert about a high failure rate of queries to the backend database cluster of our hypothetical LAMP stack.

After some investigation, the engineer dealing with the page may attempt to deal with the alert by implementing simple fallback logic for the query. If the query fails against the first database, try against the second database. This works, for a time. But what if the problem was actually the query itself being written poorly? Now the query hits the first database, causes it to go into a performance death spiral, then it hits the second database, and has the exact same effect.

Before any "solution" was put in place, the database cluster would have a single node failing. Afterwards, there is a cascading effect as every database in the cluster is getting slowed to a crawl by a single poorly written query.

The thing is, with incomplete information, and with the business pressure to respond quickly to the page, implementing a simple fallback for the query is a quick and dirty solution to the problem. This is not to say that fallback logic is always a bad idea, but in this made-up scenario, the fallback logic does not actually solve the problem.

However, it is probably unreasonable to expect the root cause of the slow query to be identified without knowing how the whole system works, without being able to monitor it in detail, and without giving a specific alert.

Instead, if there was a specific alert which was able to distinguish between specific queries and their response times, it would have been much easier for the engineer to identify that the problem was not at the database level, but at the application level. There would be no need to guess at a solution, and ultimately implement something that causes more problems to the system as a whole than if nothing were changed at all.

And unfortunately, despite how ridiculous the example above is, what I see is that people will actually go for the low-hanging fruit solutions unless they are specifically given the tools to easily get to the root cause of the problem.

If there is an alert about a disk filling up, do you delete the data written to the disk, or do you increase the volume size? With no context to what is actually happening, with no understanding of what data is safe to delete, and no knowledge of if there is an automated disk cleaning service, an engineer is forced to increase the volume size. Resulting in requiring more SSDs for their servers so they can add it to a volume group, or higher storage costs in a cloud environment.

If there is an unresponsive Java application due to falling into Garbage Collection Hell, is the solution to remove it from the loadbalancer and reboot it? Or should a memory leak be investigated? It's much easier to implement logic in Apache/Nginx/ELB to simply remove the problematic worker from the loadbalancer and give it a kick.

Once these hacky solutions start coming in, with one-off shellscripts lying around to respond to situations, and random quick solutions to application misbehaviours, it increases the cognitive load on the engineers that are ultimately running the system. They have to keep adding bespoke tools to their arsenal and begin to build up tribal knowledge of how to deal with particular scenarios due to the past system design decisions made to address issues. It can get to the point that the environment becomes so intricate that new hires begin to need several months to get up to speed with the system, and the loss of any of the old guard can shake the team to the core.

All this because of a decision to skip, or the ignorance towards, the need to improve a system so that it requires less, not more brilliance to maintain it.

I haven't even gotten into writing simple, modular code, so that future maintainers of the code can reduce cognitive load by changing small pieces of it without undue concern about the entire application falling apart at the seams to do any small change.

[Relevant XKCD](https://imgs.xkcd.com/comics/data_pipeline.png)
