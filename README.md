# Customer Support Copilot -- Comprehensive README

## Overview

This project implements an AI-powered helpdesk assistant that
classifies, retrieves, and responds to customer support tickets. It
combines query routing, Retrieval-Augmented Generation (RAG), few-shot
prompting, and multi-agent orchestration to provide real-time support
and intelligent escalation.

## Core Components & Workflow

### User Interaction

-   **Streamlit UI (app.py)**: Presents a Ticket Dashboard showing
    Topic, Sentiment, Priority, Escalation status, and final AI
    response.
-   Interactive Agent: Chat-style interface to submit new tickets.

### Classification & Sentiment

-   **Classifier Agent (classifier_agent.py)**: Uses Gemini-2.5-flash
    for Topic & Priority classification.
-   Local RoBERTa sentiment model and heuristics to refine tags like
    Frustrated, Angry, Curious.

### Retrieval-Augmented Generation (RAG)

-   **Vector Store**: Built with vector_store.py from PDFs/TXT in
    data/secure-agent. Uses FAISS with
    sentence-transformers/all-MiniLM-L6-v2 embeddings.
-   **RAG Agent (rag_agent.py)**: Calls classify_ticket, retrieves
    relevant documents, and drafts an answer.
-   EscalationDecisionEngine scores complexity, sentiment urgency, topic
    criticality, and answer quality.

### Multi-Agent Orchestration

-   **MultiQueryAgent (mquery_agent.py)**: Maintains conversation
    context and uses a decision prompt to route each query: RAG vs
    NO_RAG.
-   **Quality Agent (quality_agent.py)**: Evaluates final responses for
    coverage and quality, can trigger escalation.
-   **Ticket Agent (ticket_agent.py)**: Generates unique ticket IDs and
    stores query, classification, response, and escalation info.

## End-to-End Flow

User → Streamlit UI → MultiQueryAgent → Decision: RAG needed?\
Yes → RAGAgent → classify_ticket → FAISS retrieve_and_answer →
EscalationDecisionEngine\
No → Direct Gemini response → QualityAgent evaluation → TicketAgent
stores ticket + escalation → Streamlit dashboard updates

## Key Techniques

-   **Query Routing**: LLM prompt decides RAG vs. direct answer.
-   **Few-Shot Prompting**: Context window of last 6 messages for
    coherent multi-turn responses.
-   **RAG with FAISS**: Local vector DB for fast, citation-ready
    retrieval.
-   **4 Agents**: Classifier, RAG, MultiQuery/Quality, Ticket.
-   **Comprehensive Prompting**: Carefully structured decision,
    combined-answer, and fallback prompts.
-   **Escalation Logic**: Weighted scoring on complexity, sentiment
    urgency, topic criticality, and answer quality.

## Setup & Run

``` bash
git clone <repo_url>
cd customer-support-copilot
pip install -r requirements.txt

cp .env.example .env  # add GOOGLE_API_KEY and optional ESCALATION_THRESHOLD

python agent/vector_store.py   # builds FAISS index
streamlit run agent/app.py
```

## Deployment

Deploy easily to Streamlit Cloud, Vercel, or Railway. Ensure the FAISS
index and .env are included.

## Evaluation Tips

-   Bulk classification: Load provided sample_tickets file and check
    dashboard.
-   RAG answers: Ask "How do I enable SSO with Okta?" to see docs-based
    response with citations.
-   Escalation: Try an angry or critical query like "Your billing system
    double-charged me!".

## Architecture Diagram

             ┌─────────────┐
             │  Streamlit  │
             └─────┬───────┘
                   │
          ┌────────▼────────┐
          │ MultiQueryAgent │
          └─┬─────────────┬─┘
            │             │
       ┌────▼────┐   ┌────▼────┐
       │ RAGAgent│   │ Gemini  │
       └────┬────┘   └─────────┘
            │
     ┌──────▼───────┐
     │ FAISS Vector │
     └──────────────┘

## Key Files

  -----------------------------------------------------------------------
  File                           Purpose
  ------------------------------ ----------------------------------------
  app.py                         Streamlit UI

  classifier_agent.py            Topic/Priority classification + local
                                 sentiment

  rag_agent.py                   Retrieval + escalation

  mquery_agent.py                Conversation, query routing

  quality_agent.py               Response evaluation

  ticket_agent.py                Ticket creation/storage

  retrieval.py                   FAISS retrieval helper

  vector_store.py                Build/update vector DB
  -----------------------------------------------------------------------
