# Agent Prompt: The "Technical Interview" Quiz App

## Objective
The USER wants to be quizzed on the technical decisions and architectural standards implemented in the `YMCA 360` project. Your goal is to build a simple, interactive **Flutter Web App** (or a CLI tool, if preferred) that acts as a "Mock Interviewer".

## Instructions for the Agent
1.  **Read the Context**:
    *   Review `AGENT_HANDOFF.md` to understand the completed features (Riverpod, Remote Config, etc.).
    *   Review `PROFESSIONAL_DEV_CHECKLIST.md` to understand the *why* behind each decision.

2.  **Build the Quiz App**:
    *   **Format**: A simple Card-based UI (like Flashcards) or a Multiple Choice Quiz.
    *   **Content**: Generate 10-15 questions based *specifically* on this project's code.
    *   **Examples**:
        *   "Why did we move from `setState` to `Riverpod` in `main.dart`?"
        *   "What prevents the app from crashing if 10,000 users sign up?" (Answer: Pagination/Limits).
        *   "How do we update the Childcare URL without an app store release?" (Answer: Remote Config).
        *   "Which file contains the implementation for Feature Flags?"

3.  **Features**:
    *   **Show Answer**: A button to flip the card and reveal the "Professional" answer.
    *   **Score**: Keep track of simple correct/incorrect.
    *   **Deep Dive**: If the user gets it wrong, offer to open the relevant file (e.g., `user_repository.dart`) to show the code.

4.  **Tone**:
    *   The app should feel like a friendly Senior Developer conducting a code review or interview prep session.

## Quick Start Command
To get started, the agent should run:
`flutter create interview_prep_app`
Then use the knowledge from `PROFESSIONAL_DEV_CHECKLIST.md` to populate the `QuestionBank` class.
