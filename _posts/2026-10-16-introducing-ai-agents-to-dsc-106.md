---
title: 'Introducing AI Agents To DSC 106'
author: 'Susana Haing'
author_id: susana-haing
collaborators:
  - lauren-lee
  - thaarak-sriram
excerpt: 'Building an NRP-powered AI coding harness to improve student accessibility and study how agentic AI can support learning.'
topic: 'Tools · Agents in 106'
cover: /assets/images/blog/agents-in-106/blog-cover.jpg
cover_alt: 'Building Accessible Coding Agents for DSC 106 Students.'
---

## Background

Working with coding agents has become industry standard, but many students can't afford frontier services like Claude Code and Codex. Our team built a free agentic coding setup for students in DSC 106, running on the National Research Platform (NRP), a research computing platform that provides free access to a range of open-weight AI models.

With this harness, students have access through OpenCode, Claude Code, or Codex to various open-weight models provided by the NRP, such as Kimi, Qwen, and GPT oss. Additionally, if through OpenCode, students will have access to more models that come built in. This lets students experiment and work with different types of models, rather than being locked into one model only.

Besides tackling the accessibility issue, we also hope to use this harness to answer two questions later down the line:

1. What are the most effective students doing to aid their learning?
2. What are some habits/techniques with agentic AI that should be taught to students when courses begin to focus more on agentic AI coding?

Answering either one means capturing student interaction logs. That raised two questions of its own: what do we want to track, and how do we get it?

## The Framework

Originally, the harness was only configured through OpenCode, which already has a detailed and automatic logging system built into its software. In accessing those logs, we were able to view items such as the raw conversation text, reasoning traces, file diffs, and more, which is much more detailed than expected without needing any custom logging system. However, OpenCode is less well-known than other AI coding tools, so to provide students with a more familiar experience working with coding agents, we also configured the harness through Claude Code and Codex.

## Incompatible?

For each system, we wrote a launch script that loads the student's NRP token, and points the agent at the NRP to start it. Codex worked with the NRP's API format directly once we turned off two features: built-in web search and multi-agent mode, both of which had attributed to the NRP rejections. However, Claude Code was harder because of Anthropic’s Messages API format, as the NRP’s gateway only accepts OpenAI’s API format. The two authenticate differently, put the system prompts in different places, and represent tool calls and replies differently, so the NRP rejects Claude Code’s requests. To fix this, we used LiteLLM, an open-source tool that converts API calls from one provider’s format into another’s, in between, so Claude Code can talk to the NRP, acting as a translator. The script installs LiteLLM into a virtual environment inside the repo, starts it in the background, and shuts it down when the session ends.

The main problem was that most NRP models did not work reliably with these agents. Codex only worked with MiniMax-M2, and Claude Code only worked with MiniMax-M2 and GPT-OSS. Kimi could make exactly one tool call before the NRP rejected a field in the reasoning data that Codex sent back, which breaks any multi-step task. GLM failed on the very first message, and we confirmed this was not the agent's fault: a bare, minimal request sent straight to NRP with no agent involved was rejected the same way.

<figure markdown="0" style="max-width: 800px; margin-left: auto; margin-right: auto;">
  <img src="/assets/images/blog/agents-in-106/nrp-bug.png" alt="NRP Formatting Compatability Bug in Claude Code.">
</figure>

That is a bug in NRP's gateway. Rather than let a student pick a model that is known to fail, each script now offers only the models we confirmed end to end.

## What about the students?

Students also needed one simple way to start any of the three: a start.sh script asks which agent they want and, where there is a choice, which model.

Following setting up the harness, we needed to ensure there was a logging system that worked with accessible data. As the end goal of this was to deploy to DSC 106, a course that averages at least 100 students per term, it was important to ensure interactions were logged properly. To do this, we simulated several “students” running various types of tasks at the same time, and verified the logs continued to be correctly isolated despite coming from different sources. With OpenCode, we also confirmed that using a proxy to forward requests to the NRP as a midpoint to log interactions worked well, even across the multiple simulated students. However, the same has yet to be tested for both the Claude Code and Codex configurations.

## Future Work

Presently, we have the base setup completed, and plan to run a small pilot in the near future with actual DSC 106 students to determine whether they find the tool more useful or not than general coding agents for the class. Considering this harness will be grounded in the course material, we hope to see positive feedback from the students, and if so, will iterate to have more useful tools within the harness, such as an agent specifically designed to assist with the labs or projects.

However, the pilot would require students to manually export their interaction logs to us, rather than us being able to automatically pull it remotely. This is because we have yet to determine how to aggregate all the logs across the 3 systems properly, and how to prevent only DSC 106 students from accessing the harness. For future steps in logging, we would convert OpenCode’s database and the session files Claude Code and Codex already save into one shared format. For access, we should look into issuing each student their own NRP token, which would limit the harness to enrolled students and allow us to match logs to students without manual exports. All of these fall under next steps for the project as we wrap up for the summer.
