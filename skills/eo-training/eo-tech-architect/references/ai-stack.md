# Agentic / AI Stack - eo-tech-architect

AI component recommendations and decision tree.

## AGENTIC / AI STACK

Only recommend AI components when the student's product genuinely requires them. "AI-powered" is not a feature, it solves a specific user problem.

| Technology | Use Case | When to Recommend |
|-----------|----------|-------------------|
| Claude Code (required) | Development partner, code generation, debugging | ALWAYS: this is the primary build tool for Step 5 |
| Claude Agent SDK | Custom AI agents embedded in the product | When product requires autonomous AI workflows |
| LangChain / LangGraph | Complex chains, tool use, structured outputs | When product needs multi-step AI reasoning with state |
| LlamaIndex | RAG pipelines, document Q&A, knowledge bases | When product ingests and queries unstructured data |
| CrewAI | Multi-agent collaboration workflows | When product needs specialized agents working together |
| Gemini API | Vision, long-context, cost-effective inference | When Claude costs are prohibitive or vision tasks dominate |
| n8n AI nodes | No-code AI workflow integration | When AI features connect to existing n8n automations |

### AI Stack Decision Tree

```
Does the product need AI features for END USERS (not just for building)?
├── NO → Skip AI stack entirely. Claude Code is sufficient for development.
├── YES → What kind of AI?
│   ├── Chat/conversational → Claude API or Gemini API (cost comparison)
│   ├── Document processing → LlamaIndex + Supabase pgvector
│   ├── Multi-step workflows → LangChain/LangGraph or CrewAI
│   ├── Image/vision → Gemini API (cost) or Claude Vision (quality)
│   └── Automation glue → n8n AI nodes
```

---

