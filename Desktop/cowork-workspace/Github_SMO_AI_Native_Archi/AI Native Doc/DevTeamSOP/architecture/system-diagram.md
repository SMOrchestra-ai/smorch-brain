# AI-Native Organization — System Architecture Diagram

**Date:** 2026-03-30
**Version:** 1.0

## Full System Flow

```mermaid
flowchart TD
    subgraph CEO["CEO Layer (Mamoun)"]
        TG["@SMOQueueBot<br/>Telegram"]
        PP["Paperclip<br/>localhost:3100"]
    end

    subgraph COO["COO Layer (Queue Engine on smo-brain)"]
        N8N["n8n-mamoun<br/>Orchestration"]
        DB[(queue.db<br/>SQLite WAL)]
        DECOMP["decompose-brd.sh"]
        DISPATCH["dispatch.sh"]
        SCORE["score-task.sh"]
        COMPLETE["task-complete.sh"]
        HEALTH["health-check.sh"]
        NOTIFY["notify-ceo.sh"]
        APPROVE["queue-approve.sh"]
        STATUS["queue-status.sh"]
        CLASSIFY["classify-task.sh"]
        ADDTASK["add-task.sh"]
        CREATEPR["create-pr.sh"]
        DBLIB["db.sh<br/>SQL Safety Layer"]
    end

    subgraph NODES["Execution Nodes"]
        BRAIN["smo-brain<br/>100.89.148.62<br/>Account A"]
        DEV["smo-dev<br/>100.117.35.19<br/>Account B"]
        DESK["desktop<br/>100.100.239.103<br/>Account A shared"]
    end

    subgraph GIT["GitHub"]
        REPO["SMOrchestra-ai/*<br/>repos"]
        CI["GitHub Actions<br/>CI/CD"]
        PR["Pull Requests"]
    end

    %% CEO → COO
    TG -->|"/brd text"| N8N
    PP -->|"BRD entry"| N8N
    TG -->|"/approve /kill /status"| APPROVE
    TG -->|"/status"| STATUS

    %% n8n → Scripts
    N8N -->|"BRD intake"| DECOMP
    N8N -->|"2min cron"| DISPATCH
    N8N -->|"CI webhook"| SCORE

    %% Decomposition
    DECOMP -->|"Claude decomposition"| ADDTASK
    ADDTASK -->|"INSERT"| DB

    %% Dispatch
    DISPATCH -->|"READ task"| DB
    DISPATCH -->|"classify"| CLASSIFY
    DISPATCH -->|"SSH/local"| BRAIN
    DISPATCH -->|"SSH"| DEV
    DISPATCH -->|"SSH"| DESK

    %% Execution → Completion
    BRAIN -->|"agent done"| COMPLETE
    DEV -->|"agent done"| COMPLETE
    COMPLETE -->|"trigger"| SCORE

    %% Scoring → PR
    SCORE -->|"Claude scorer"| CREATEPR
    CREATEPR -->|"gh pr create"| PR

    %% All scripts use db.sh
    DBLIB -.->|"sourced by"| DISPATCH
    DBLIB -.->|"sourced by"| SCORE
    DBLIB -.->|"sourced by"| COMPLETE
    DBLIB -.->|"sourced by"| ADDTASK
    DBLIB -.->|"sourced by"| CREATEPR
    DBLIB -.->|"sourced by"| APPROVE
    DBLIB -.->|"sourced by"| STATUS

    %% Notifications
    NOTIFY -.->|"Telegram API"| TG
    COMPLETE -->|"on failure"| NOTIFY
    CREATEPR -->|"HIGH/MED risk"| NOTIFY
    DECOMP -->|"BRD ready"| NOTIFY

    %% Health
    HEALTH -->|"checks"| DB
    HEALTH -->|"checks"| N8N

    %% Styling
    classDef ceo fill:#4CAF50,color:#fff
    classDef coo fill:#2196F3,color:#fff
    classDef node fill:#FF9800,color:#fff
    classDef git fill:#9C27B0,color:#fff
    classDef safety fill:#F44336,color:#fff

    class TG,PP ceo
    class N8N,DB,DECOMP,DISPATCH,SCORE,COMPLETE,HEALTH,NOTIFY,APPROVE,STATUS,CLASSIFY,ADDTASK,CREATEPR coo
    class BRAIN,DEV,DESK node
    class REPO,CI,PR git
    class DBLIB safety
```

## Data Flow: BRD to Merge

```mermaid
sequenceDiagram
    actor CEO as Mamoun (CEO)
    participant TG as @SMOQueueBot
    participant N8N as n8n
    participant DEC as decompose-brd.sh
    participant DB as queue.db
    participant DIS as dispatch.sh
    participant AGT as Claude Agent
    participant GH as GitHub
    participant SCR as score-task.sh
    participant PR as create-pr.sh
    participant NOT as notify-ceo.sh

    CEO->>TG: /brd "Build health check for EO"
    TG->>N8N: Webhook trigger
    N8N->>DEC: Execute decomposition
    DEC->>DB: CREATE BRD-001
    DEC->>DB: INSERT TASK-006..TASK-010
    DEC->>NOT: brd_decomposed
    NOT->>TG: "BRD decomposed into 5 tasks"
    CEO->>TG: /approve-all
    TG->>DB: UPDATE status → queued

    loop Every 2 minutes
        N8N->>DIS: Check for queued tasks
        DIS->>DB: SELECT queued + dependency check
        DIS->>AGT: SSH dispatch to smo-dev
        AGT->>GH: git push agent/TASK-006-*
        AGT->>DB: task-complete.sh → scoring
        SCR->>AGT: Claude scores diff
        alt Score >= 8
            SCR->>PR: create-pr.sh
            PR->>GH: gh pr create
            PR->>NOT: pr_ready (HIGH/MED)
            NOT->>TG: "PR ready for review"
        else Score < 8, retries < 2
            SCR->>DB: status → queued (retry)
        else Score < 8, retries >= 2
            SCR->>PR: PR with needs-quality-review
        end
    end
```

## Database Schema (ERD)

```mermaid
erDiagram
    brds ||--o{ tasks : "spawns"
    tasks ||--o{ file_locks : "locks"
    tasks ||--o{ task_artifacts : "produces"
    tasks ||--o{ audit_log : "logs"
    tasks ||--o{ dead_letters : "fails to"
    accounts ||--o{ node_accounts : "owns"
    role_skills }|--|| tasks : "defines role"

    brds {
        text id PK "BRD-001"
        text title
        text source "telegram|paperclip|manual"
        text raw_text
        int task_count
        text status
    }

    tasks {
        text id PK "TASK-001"
        text brd_id FK
        text title
        text repo
        text goal
        text role
        text tier
        text status
        text branch
        text pr_url
        real quality_score
        int retry_count
    }

    dead_letters {
        int id PK
        text task_id FK
        text failure_reason
        text last_error
        bool resolved
    }

    accounts {
        text id PK "A, B"
        text name
        int monthly_cap_cents
    }

    node_accounts {
        text node PK
        text account_id FK
        int max_concurrent
    }
```

## Infrastructure Topology

```mermaid
graph LR
    subgraph Tailscale["Tailscale Mesh (100.x.x.x)"]
        B["smo-brain<br/>100.89.148.62<br/>Queue Engine + n8n<br/>Account A ($200)"]
        D["smo-dev<br/>100.117.35.19<br/>Primary Build Server<br/>Account B ($200)"]
        K["desktop<br/>100.100.239.103<br/>Paperclip + QA<br/>Account A (shared)"]
    end

    B <-->|SSH + rsync| D
    B <-->|Tailscale| K
    D <-->|Tailscale| K

    GH["GitHub<br/>SMOrchestra-ai/*"]
    TG["Telegram API<br/>@SMOQueueBot"]

    B -->|webhooks| GH
    B -->|bot API| TG
```
