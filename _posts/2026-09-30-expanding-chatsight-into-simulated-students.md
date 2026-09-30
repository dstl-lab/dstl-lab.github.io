---
title: "Expanding ChatSight into Simulated Students"
author: "Minchan Kim"
author_id: minchan-kim
collaborators:
  - steven-xu
  - austin-flippo
excerpt: "From labeling student–AI conversations to simulating how students might respond to changes in AI tutor behavior."
topic: "Research update · ChatSight"
cover: /assets/images/blog/chatsight-simulated-students/simulated-students.png
cover_alt: "Changing an AI tutor leads to different student responses."
---

## Background

### Foundations

<figure markdown="0" style="max-width: 560px; margin-left: auto; margin-right: auto;">
  <img src="/assets/images/blog/chatsight-simulated-students/foundations.png" alt="Student conversations move from human labeling to automated labeling.">
</figure>

Throughout SY25-26, the ChatSight team worked to help instructors understand the ways students are utilizing course-specific large language models (LLM) to assist with their assignments. This problem was tackled by proposing a dual-labeling solution with the overarching goal of creating labels and applying them from a bottom-up approach. However, during this summer, we wanted to explore what would happen if we spent more time from a top-down approach. By having an LLM create its own labels and applying it on its own, we theorized that through multiple iterations we would have a prototype that provides “good enough” labels that would expedite the labeling process we observed during ChatSight’s case studies. 

### Top-Down?

<figure markdown="0" style="max-width: 560px; margin-left: auto; margin-right: auto;">
  <img src="/assets/images/blog/chatsight-simulated-students/top-down-labels.png" alt="An AI creates similar labels that leave a human reviewer puzzled.">
</figure>

However, after a couple of internal experiments in which we evaluated the LLM’s labels through a human perspective, we found that despite providing sufficient context to the LLM such as assignment, course, and common student behaviors, the labels the LLM would create would often be very broad and have labels that mirror one another (but with a distinction so minute that humans wouldn’t be able to detect a difference). A few examples and the labels’ definitions are supplied below.

- **“asks-for-direct-answer” vs. “Direct Solution Request”** : LLM drafted a label that already existed under another name. A clear duplication of labels.
    - asks-for-direct-answer: “The student’s message explicitly requests the exact solution, answer, or specific code output for an assignment problem.”
    - Direct Solution Request: “Student explicitly asks for the complete or correct code to solve a problem or a specific part of an assignment.”
- **“Confusion” vs. “Debugging Request”** : Although conceptually different, model’s use of *Confusion* collapsed into “the student asked a question.” Since student queries are typically short and most don’t show emotions in their prompts, the model attempted to make this label “useful” by applying it to a broader unnecessary scope, which overlapped strongly with debugging requests.
    - Confusion: “Student indicates a lack of understanding a concept, error, or expected output, often in a questioning tone.”
    - Debugging Request: “Student seeks assistance in identifying and resolving errors in their code.”
- **“Code Implementation Query” vs. “step-by-step-prompt”** : The system treated these as separate categories, but repeatedly tagged the same messages. *Code Implementation Query* eventually became an “asked a question” catch-all, which is essentially most student queries.
    - Code Implementation Query: “Student asks for guidance on how to write code to achieve a specific task or complete an assignment question.”
    - step-by-step-prompt: “Student asks for the immediate next step or a sequence of instructions to solve a problem, without providing their own attempt or specific points of difficulty.”

At some point, we began to ask ourselves **what the point of labeling is in the first place**. Sure, it provides an insight to instructors to see how students are using LLMs, but most of the behavior was to be expected. To truly utilize these labels, we moved into creating simulated students, but we weren’t sure if continuing to explore labeling taxonomy was the right direction. 

### Simulated Students???

<figure markdown="0" style="max-width: 560px; margin-left: auto; margin-right: auto;">
  <img src="/assets/images/blog/chatsight-simulated-students/simulated-students.png" alt="Changing an AI tutor leads to different student responses: working, asking questions, or leaving.">
</figure>

Until now, we primarily focused on past and current student transcripts. However, what if we expanded this to the future? What if we could see how students would respond to evolving course policies such as a different system prompt supplied to a course-specific LLM? In DSC 10’s case, what would happen if the tutor…

1. …was more resistant to giving the answer? Would students simply stop using the tutor or would they evolve?
2. …simply gave the answer? Would students still ask questions to deepen their understanding?
3. …changed the tone of their response? Would students be more receptive to feedback?
4. …required students to show an attempt before providing help? Would students begin sharing their reasoning, try jailbreaking the model to unlock help, or leave?
5. …offered a choice between a hint, an explanation, and a worked example? Which forms of help would students choose, and would those choices change after success of failure?
6. and so many more questions!

Of course, though we are limited by the data we have right now, it would be really interesting to see how different student populations would respond to changes before it even goes into effect. 

### Sequences

<figure markdown="0" style="max-width: 560px; margin-left: auto; margin-right: auto;">
  <img src="/assets/images/blog/chatsight-simulated-students/sequences.png" alt="Illustration accompanying the analysis of student activity sequences.">
</figure>

To resolve the labeling taxonomy issue, Austin suggested using sequences within transcripts instead of labeling individual messages. For example,

```jsx
attempt -> error -> help -> revision -> check -> etcetc.
```

Since we now had to look into the full transcript, we ingested new data: tutor conversations, notebook captures, autograder results, and timestamps. We grouped conversations into three rough patterns with an initial pilot:

| **Before the conversation** | **After the conversation** |
| --- | --- |
| **Ask-first**: no grader run observed in preceding window | Pass, fail, or no grader run observed afterward |
| **Fail-then-ask**: a failed check before asking | Pass, another failure, or no subsequent check |
| **Pass-then-ask**: a passing check before asking | Further checking or no subsequent check |

From these three groups, events were roughly **56% pass-then-ask, 27% ask-first, and 17% fail-then-ask.**

Yet, taking data from just the chat alone misses most student activity as the bulk of what the student does is on the notebook. So instead of just relying on replies students make, it was essential to see all stages of the students’ behavior: editing, checking, and communicating.

### Simulations

<figure markdown="0" style="max-width: 560px; margin-left: auto; margin-right: auto;">
  <img src="/assets/images/blog/chatsight-simulated-students/simulations.png" alt="Comparing real and simulated students helps instructors adjust AI tutor behavior.">
</figure>

The sequence work revealed that generating a simulated student requires more than just generating their next message. Since students also edit code, run checks, and work silently, we built a prototype that could perform these actions, receive feedback, and continue through saved interactions with a tutor. Yet, this working simulation was not necessarily a realistic student because early reviews found that although generated replies *could align* with recorded students, the simulator often supplied code or explanations where real students requested help.

This is where our research for the summer has culminated in. We are hoping to analyze incoming notebook data from FA26’s rendition of DSC 10 and improve creating realistic students. And so, our research question remains: **Can an LLM simulate a randomly chosen DSC 10 student’s AI usage and how can it be improved from this baseline to assist instructors with their LLM tool instructions?**

## Next Steps

With data coming in from this quarter’s DSC 10, we are excited to see how our research question is iterated upon! We also split this task into two branches:

1. Simulated student workspace interface
2. Reconstructing student journeys

<div class="grid blog-grid" markdown="0">
<figure>
  <img src="/assets/images/blog/chatsight-simulated-students/simulation-workspace.png" alt="Student lab simulation workspace showing a saved student question and tutor response.">
</figure>

<figure>
  <img src="/assets/images/blog/chatsight-simulated-students/student-journeys.png" alt="Student Question Interactions dashboard showing synthetic student activity, tutor questions, errors, and autograder results.">
</figure>
</div>
