# Prompt necesario para cada iteracion: 

PROMPT REAL PARA AI:
Actúa como senior ML engineer especializado en LLM fine-tuning.

CONTEXTO BASE:
Referencia el documento "CodeReviewer Pro - Especificaciones Técnicas Completas" para el contexto completo del proyecto, incluyendo arquitectura, stack tecnológico, performance requirements, y business model.

TAREA ESPECÍFICA:
[Aquí pegas el Prompt 3.1 completo de LoRA Fine-tuning]

REQUIREMENTS ADICIONALES:
- Usar stack ML optimizado para 8GB VRAM: CodeLlama-7B o CodeGPT-small + LoRA + HuggingFace Transformers
- Optimizar para RTX 4070 (8GB VRAM) con 4-bit quantization y CPU offloading
- Seguir performance targets: <30 segundos inference según API specs
- Implementar monitoring según las métricas definidas en el doc


# 🚀 CodeReviewer Pro - AI Prompts Completos
## Prompts Específicos para Desarrollo Acelerado con AI

---

## 📋 **FASE 1: PROJECT SETUP Y ENVIRONMENT**

### **Prompt 1.1: Project Structure Setup**
```
Actúa como un senior ML engineer especializado en proyectos AI SaaS. Necesito crear la estructura completa de un proyecto llamado "CodeReviewer Pro" - una AI que analiza código y genera reviews detallados.

CONTEXTO TÉCNICO:
- Desarrollador C# con Python básico
- Hardware: RTX 4070 (8GB VRAM) + 64GB RAM
- Target: API SaaS con FastAPI + React frontend
- Deployment: HuggingFace Spaces + Vercel
- Budget: $0 inicial (bootstrap approach)
- VRAM Constraint: 8GB requiere modelos 7B max con 4-bit quantization

GENERA EXACTAMENTE:

1. **Estructura de carpetas completa** con explicación de cada directorio
2. **requirements.txt** con versiones exactas optimizadas para RTX 4070 (8GB VRAM)
3. **Dockerfile** para development y production
4. **docker-compose.yml** con servicios necesarios (PostgreSQL, Redis)
5. **.env.example** con todas las variables necesarias
6. **.gitignore** específico para proyectos ML
7. **pyproject.toml** con configuración de proyecto
8. **Makefile** con comandos útiles para development
9. **README.md** con setup instructions
10. **environment setup script** (setup.sh) para automatizar instalación

REQUERIMIENTOS ESPECÍFICOS:
- Compatible con Windows 11 + WSL2
- Usar Python 3.11
- CUDA 11.8 compatibility
- Include pre-commit hooks
- Support para Jupyter notebooks
- Logging configuration
- Testing setup con pytest

FORMATO DE OUTPUT:
- Cada archivo completo con contenido
- Comentarios explicativos en código
- Instrucciones de uso paso a paso
- Troubleshooting común
```

### **Prompt 1.2: Development Environment Configuration**
```
Actúa como DevOps engineer especializado en ML environments. Necesito configuración completa para desarrollo de "CodeReviewer Pro".

CONTEXTO:
- Windows 11 + WSL2 Ubuntu 22.04
- RTX 4070 con 8GB VRAM
- Python 3.11 + CUDA 11.8
- Project stack: FastAPI + React + PostgreSQL + Redis

GENERA EXACTAMENTE:

1. **environment.yml** (conda) con dependencias exactas
2. **pip-tools** setup con requirements.in y constraints
3. **VS Code configuration**:
   - .vscode/settings.json con Python + ML extensions
   - .vscode/launch.json para debugging
   - .vscode/tasks.json para automation
   - .vscode/extensions.json recomendadas
4. **GPU validation script** (test_gpu.py) que verifique:
   - CUDA availability
   - PyTorch GPU detection
   - Memory allocation test
   - Performance benchmark
5. **Database setup scripts**:
   - PostgreSQL initialization
   - Redis configuration
   - Migration scripts básicos
6. **Logging configuration** (logging.conf)
7. **Pre-commit configuration** (.pre-commit-config.yaml)
8. **pytest configuration** (pytest.ini)
9. **Environment health check script** (health_check.py)

REQUERIMIENTOS ESPECÍFICOS:
- Detectar automáticamente GPU capabilities
- Optimize memory usage para 8GB VRAM con CPU offloading
- Include profiling tools (memory, GPU usage)
- Support para remote development
- Hot reload para development
- Automated testing pipeline

INCLUDE:
- Installation troubleshooting guide
- Performance optimization tips
- Common error solutions
- Development best practices
```

---

## 📊 **FASE 2: DATA COLLECTION SYSTEM**

### **Prompt 2.1: GitHub Repository Scraper**
```
Actúa como senior data engineer especializado en web scraping y ML datasets. Necesito un sistema completo para recopilar code reviews de GitHub para entrenar un modelo AI.

CONTEXTO TÉCNICO:
- Target: 15,000 ejemplos de code reviews de calidad
- Lenguajes: JavaScript, Python, TypeScript, Java
- Source: GitHub public repositories con MIT/Apache licenses
- Rate limiting: GitHub API (5000 requests/hour)
- Storage: JSON files + PostgreSQL

GENERA EXACTAMENTE:

1. **github_scraper.py** - Clase principal con métodos:
   - get_popular_repos(language, min_stars, license_filter)
   - get_pull_requests(repo, state, filters)
   - get_pr_reviews(repo, pr_number)
   - get_pr_files(repo, pr_number)
   - get_pr_diff(repo, pr_number)
   - rate_limit_handler() con exponential backoff
   - error_handling con retry logic

2. **license_validator.py** - Sistema para validar licencias:
   - check_repo_license(repo_url)
   - is_commercial_friendly(license_type)
   - license_compatibility_matrix
   - legal_compliance_checker()

3. **quality_filter.py** - Filtros de calidad para reviews:
   - is_constructive_review(review_text)
   - has_code_suggestions(review_text)
   - is_educational(review_text)
   - calculate_quality_score(review)
   - filter_spam_reviews()

4. **data_collector.py** - Orchestrator principal:
   - collect_from_repo_list(repos, max_examples_per_repo)
   - parallel_collection con threading
   - progress_tracking con estimated time
   - resume_from_checkpoint()
   - save_progress_periodically()

5. **repo_selector.py** - Selección inteligente de repos:
   - find_high_quality_repos(language, criteria)
   - repo_activity_analyzer()
   - code_review_frequency_checker()
   - maintainer_quality_assessment()

REQUERIMIENTOS ESPECÍFICOS:
- Handle GitHub API rate limits elegantly
- Support para GitHub personal tokens múltiples (rotation)
- Resume capability si se interrumpe
- Progress bar con ETA
- Logging detallado con different levels
- Export en multiple formatos (JSON, CSV, Parquet)
- Validate data integrity
- Remove PII automatically (emails, tokens, etc.)

INCLUDE:
- Configuration file (config.yaml)
- CLI interface con argumentos
- Monitoring dashboard básico
- Unit tests para cada componente
- Documentation completa
- Example usage scripts
- Error recovery mechanisms
```

### **Prompt 2.2: Stack Overflow Data Scraper**
```
Actúa como data scientist especializado en text processing y web APIs. Necesito scraper completo para Stack Overflow code reviews.

CONTEXTO:
- Target: Preguntas tagged 'code-review' + lenguaje específico
- Focus: High-quality answers (score >= 3)
- API: Stack Exchange API v2.3
- Rate limit: 300 requests/day por IP
- Output format: Consistent con GitHub scraper

GENERA EXACTAMENTE:

1. **stackoverflow_scraper.py** - Core scraper:
   - search_questions(tags, filters, pagination)
   - get_question_details(question_id, include_body=True)
   - get_answers(question_id, min_score, sort_by_votes)
   - extract_code_blocks(html_content)
   - parse_answer_content(html_content)

2. **html_parser.py** - HTML processing:
   - extract_code_snippets(html)
   - clean_markdown_content(content)
   - separate_code_from_explanation(content)
   - detect_programming_language(code_block)
   - remove_formatting_artifacts()

3. **content_analyzer.py** - Content quality analysis:
   - is_code_review_answer(answer_text)
   - contains_actionable_feedback(answer)
   - calculate_educational_value(answer)
   - detect_copy_paste_answers()
   - validate_code_completeness(code_snippet)

4. **so_data_processor.py** - Data standardization:
   - convert_to_training_format(question, answer)
   - normalize_code_formatting(code)
   - extract_review_categories(feedback_text)
   - create_instruction_pairs()
   - validate_example_quality()

REQUERIMIENTOS ESPECÍFICOS:
- Handle Stack Exchange API quota elegantly
- Support para multiple Stack Exchange sites (stackoverflow, codereview.stackexchange)
- Efficient HTML parsing con BeautifulSoup4
- Code syntax highlighting detection
- Language-specific code extraction
- Deduplication logic
- Export compatibility con GitHub data format

INCLUDE:
- API key rotation system
- Caching layer para requests
- Batch processing capabilities
- Progress tracking
- Quality metrics calculation
- Data validation tests
- Integration con main data pipeline
```

### **Prompt 2.3: Data Processing Pipeline**
```
Actúa como ML data engineer. Necesito pipeline completo para procesar, limpiar y preparar datos de code reviews para training.

CONTEXTO:
- Input: Raw JSON desde GitHub + Stack Overflow scrapers
- Target output: Training-ready dataset en formato instruction-following
- Size: 15,000+ examples
- Languages: JavaScript, Python, TypeScript, Java
- Format: {"instruction": "...", "input": "...", "output": "..."}

GENERA EXACTAMENTE:

1. **data_processor.py** - Main processing engine:
   - load_raw_data(source_files)
   - clean_code_content(code_text)
   - clean_review_content(review_text)
   - normalize_formatting(content)
   - remove_personal_info(text)
   - validate_example_quality(example)

2. **code_cleaner.py** - Code-specific cleaning:
   - remove_diff_artifacts(diff_text)
   - normalize_indentation(code)
   - remove_comments_selectively(code, keep_important=True)
   - fix_encoding_issues(text)
   - standardize_line_endings(code)
   - truncate_large_files(code, max_lines=100)

3. **review_formatter.py** - Review text processing:
   - structure_feedback(review_text)
   - extract_suggestions(review)
   - categorize_issues(feedback)
   - format_as_instruction(review)
   - add_context_hints(feedback, code_context)

4. **dataset_builder.py** - Final dataset creation:
   - create_instruction_format(code, review, language)
   - balance_language_distribution(examples)
   - split_train_validation_test(dataset, ratios=[0.8, 0.1, 0.1])
   - generate_dataset_statistics(dataset)
   - export_multiple_formats(dataset, formats=['json', 'jsonl', 'parquet'])

5. **quality_validator.py** - Quality assurance:
   - check_instruction_clarity(instruction)
   - validate_code_syntax(code, language)
   - assess_review_usefulness(review)
   - detect_duplicates(examples)
   - calculate_diversity_metrics(dataset)

6. **data_augmenter.py** - Dataset augmentation:
   - create_variations(code_example)
   - generate_synthetic_issues(code)
   - paraphrase_reviews(review_text)
   - balance_categories(dataset)

REQUERIMIENTOS ESPECÍFICOS:
- Memory-efficient processing (stream large files)
- Configurable quality thresholds
- Language-specific processing rules
- Robust error handling
- Progress tracking con estimated completion
- Resumable processing
- Detailed logging con quality metrics
- Export statistics y quality reports

INCLUDE:
- Configuration file (processing_config.yaml)
- CLI interface para batch processing
- Quality assessment report generator
- Dataset visualization tools
- Unit tests para cada component
- Data validation schemas
- Performance optimization
- Memory usage monitoring
```

---

## 🧠 **FASE 3: MODEL TRAINING SYSTEM**

### **Prompt 3.1: LoRA Fine-tuning Setup**
```
Actúa como ML engineer especializado en LLM fine-tuning. Necesito sistema completo para fine-tune GPT-OSS-20b con LoRA para code review task.

CONTEXTO TÉCNICO:
- Base model: CodeLlama-7B o CodeGPT-small (7B parameters max para 8GB VRAM)
- Hardware: RTX 4070 (8GB VRAM) con 4-bit quantization obligatorio
- Method: LoRA (Low-Rank Adaptation) con rank=8, alpha=16
- Dataset: 15K code review examples
- Framework: HuggingFace Transformers + PEFT + BitsAndBytes
- Target: Code review generation task con CPU offloading

GENERA EXACTAMENTE:

1. **model_trainer.py** - Main training class:
   - load_base_model(model_name, quantization_config)
   - setup_lora_config(rank, alpha, target_modules)
   - prepare_dataset(data_path, tokenizer)
   - configure_training_args(output_dir, learning_rate, etc.)
   - train_model(model, dataset, training_args)
   - save_model_checkpoints(model, checkpoint_dir)

2. **lora_config.py** - LoRA configuration optimizada para 8GB:
   - create_lora_config(rank=8, alpha=16, dropout=0.1)  # Reduced for 8GB VRAM
   - target_modules_selector(model_architecture)
   - calculate_trainable_parameters(model)
   - memory_optimization_config()
   - gradient_checkpointing_setup()

3. **data_loader.py** - Dataset preparation:
   - CodeReviewDataset(torch.utils.data.Dataset)
   - tokenize_examples(examples, tokenizer, max_length=2048)
   - create_attention_masks(tokens)
   - format_instruction_following(examples)
   - create_data_collator(tokenizer, padding=True)

4. **training_monitor.py** - Training monitoring:
   - TrainingCallback(transformers.TrainerCallback)
   - log_memory_usage()
   - plot_training_curves(loss, learning_rate)
   - save_training_metrics(metrics, checkpoint)
   - early_stopping_logic(patience=3)

5. **model_evaluator.py** - Evaluation system:
   - evaluate_on_validation_set(model, eval_dataset)
   - calculate_perplexity(model, dataset)
   - generate_sample_reviews(model, test_codes)
   - compute_bleu_scores(generated, reference)
   - assess_review_quality(generated_reviews)

REQUERIMIENTOS ESPECÍFICOS:
- Optimize para 8GB VRAM (4-bit quantization, gradient checkpointing, fp16, CPU offloading)
- Implement resumable training
- Memory monitoring con automatic garbage collection
- Support para distributed training (future scaling)
- Automatic mixed precision
- Learning rate scheduling
- Gradient accumulation para effective large batch size
- Model quantization para efficiency

INCLUDE:
- Training configuration file (train_config.yaml)
- Hyperparameter tuning script
- Model comparison utilities
- Training resume functionality
- GPU memory optimization techniques
- Comprehensive logging
- Model versioning system
- Performance benchmarking
```

### **Prompt 3.2: Model Evaluation & Testing**
```
Actúa como ML researcher especializado en NLP evaluation. Necesito sistema completo para evaluar quality del modelo de code review.

CONTEXTO:
- Trained model: CodeLlama-7B o CodeGPT-small fine-tuned con LoRA
- Task: Code review generation
- Metrics needed: BLEU, ROUGE, custom quality metrics
- Test dataset: Hold-out set de 1500 examples
- Human evaluation: Manual quality assessment

GENERA EXACTAMENTE:

1. **model_evaluator.py** - Comprehensive evaluation:
   - load_trained_model(checkpoint_path)
   - run_automated_evaluation(model, test_dataset)
   - calculate_nlp_metrics(generated, references)
   - assess_code_review_quality(reviews)
   - generate_evaluation_report(metrics, examples)

2. **quality_metrics.py** - Custom metrics para code reviews:
   - calculate_review_usefulness_score(review, code)
   - measure_constructive_feedback_ratio(review)
   - assess_technical_accuracy(review, code_context)
   - evaluate_actionability(suggestions)
   - measure_educational_value(explanation)

3. **human_evaluation.py** - Human evaluation framework:
   - create_evaluation_interface()
   - randomize_sample_selection(test_set, n_samples=100)
   - design_rating_scales(criteria=['accuracy', 'usefulness', 'clarity'])
   - calculate_inter_annotator_agreement()
   - aggregate_human_scores(ratings)

4. **comparison_benchmark.py** - Comparison con baselines:
   - compare_with_sonarqube_rules()
   - benchmark_against_codeclimate()
   - measure_improvement_over_basic_patterns()
   - calculate_false_positive_rates()
   - assess_coverage_completeness()

5. **inference_tester.py** - Production readiness testing:
   - test_inference_speed(model, various_code_lengths)
   - measure_memory_usage_during_inference()
   - test_concurrent_requests(model, n_concurrent=10)
   - validate_output_consistency(model, same_input_multiple_times)
   - test_edge_cases(empty_code, very_long_code, syntax_errors)

REQUERIMIENTOS ESPECÍFICOS:
- Automated evaluation pipeline
- Statistical significance testing
- Confidence intervals para metrics
- Category-wise performance analysis (por language, code type)
- Error analysis con failure case categorization
- Performance profiling
- A/B testing framework preparation
- Reproducible evaluation setup

INCLUDE:
- Evaluation configuration file
- Automated report generation
- Visualization dashboard para results
- Statistical analysis scripts
- Comparison charts and tables
- Error analysis tools
- Performance benchmarking suite
- Model selection criteria
```

---

## 🚀 **FASE 4: API BACKEND DEVELOPMENT**

### **Prompt 4.1: FastAPI Backend Architecture**
```
Actúa como senior backend engineer especializado en AI API services. Necesito backend completo para CodeReviewer Pro SaaS.

CONTEXTO TÉCNICO:
- Framework: FastAPI con async/await
- Database: PostgreSQL con SQLAlchemy ORM
- Cache: Redis para rate limiting y caching
- Authentication: JWT tokens
- Model: LoRA fine-tuned CodeLlama-7B optimizado para 8GB VRAM
- Deployment: Docker containers
- Monitoring: Structured logging + metrics

GENERA EXACTAMENTE:

1. **main.py** - FastAPI application setup:
   - create_app() con middleware configuration
   - include_routers() para different modules
   - setup_cors() para React frontend
   - configure_logging()
   - setup_exception_handlers()
   - health_check endpoints

2. **routers/review.py** - Core review API:
   - POST /api/v1/review (main endpoint)
   - GET /api/v1/review/{review_id} (get results)
   - POST /api/v1/review/batch (multiple files)
   - WebSocket /ws/review (real-time streaming)
   - rate_limiting decorators
   - input validation schemas

3. **routers/auth.py** - Authentication system:
   - POST /api/v1/auth/register
   - POST /api/v1/auth/login
   - POST /api/v1/auth/refresh
   - GET /api/v1/auth/profile
   - JWT token management
   - API key generation para developers

4. **models/database.py** - SQLAlchemy models:
   - User model (id, email, subscription_tier, api_key)
   - Review model (id, user_id, code_content, review_result, created_at)
   - Usage model (user_id, date, requests_count, tokens_used)
   - Subscription model (user_id, tier, expires_at, stripe_subscription_id)

5. **services/ai_service.py** - AI model integration:
   - ModelService class con singleton pattern
   - load_model() con caching
   - generate_review(code, language, context)
   - batch_review(code_files)
   - handle_model_errors()
   - optimize_inference_speed()

6. **services/rate_limiter.py** - Rate limiting service:
   - RateLimiter class con Redis backend
   - check_rate_limit(user_id, endpoint)
   - different limits por subscription tier
   - reset_limit() functionality
   - get_usage_stats(user_id)

REQUERIMIENTOS ESPECÍFICOS:
- Async/await throughout para performance
- Input validation con Pydantic models
- Comprehensive error handling
- Request/response logging
- API versioning support
- OpenAPI documentation auto-generation
- Background task processing con Celery
- Database connection pooling
- Redis connection management
- Security headers y CORS properly configured

INCLUDE:
- Docker configuration
- Environment configuration
- Database migration scripts
- API documentation examples
- Unit tests para cada endpoint
- Integration tests
- Performance testing scripts
- Security testing checklist
```

### **Prompt 4.2: Database Design & Management**
```
Actúa como database architect especializado en SaaS applications. Necesito database design completo para CodeReviewer Pro.

CONTEXTO:
- Database: PostgreSQL 15
- ORM: SQLAlchemy con Alembic migrations
- Scale: Start small, design para 10K+ users
- Features: User management, usage tracking, billing integration
- Performance: Query optimization, indexing strategy

GENERA EXACTAMENTE:

1. **database/models.py** - Complete data models:
   - User (authentication, profile, subscription info)
   - Subscription (tiers, billing, usage limits)
   - Review (code reviews history, caching)
   - Usage (analytics, rate limiting, billing)
   - ApiKey (developer API access)
   - AuditLog (security, compliance)

2. **database/schemas.py** - Pydantic schemas:
   - UserCreate, UserResponse, UserUpdate
   - ReviewCreate, ReviewResponse
   - SubscriptionResponse
   - UsageStatistics
   - Input validation rules
   - Response serialization

3. **database/repositories.py** - Repository pattern:
   - UserRepository con CRUD operations
   - ReviewRepository con search/filter capabilities
   - UsageRepository con analytics queries
   - SubscriptionRepository con billing logic
   - Async query methods
   - Transaction management

4. **database/migrations/** - Alembic migrations:
   - Initial schema creation
   - Indexes creation
   - Subscription tiers setup
   - Performance optimizations
   - Data seeding scripts

5. **database/connection.py** - Database connection management:
   - Connection pooling configuration
   - Session management
   - Health checks
   - Retry logic
   - Connection monitoring

REQUERIMIENTOS ESPECÍFICOS:
- Optimized indexes para common queries
- Foreign key constraints
- Check constraints para data integrity
- Soft deletes donde appropriate
- Audit trail capability
- Database backup strategy
- Connection pooling optimization
- Query performance monitoring
- Migration rollback capability

INCLUDE:
- Database setup scripts
- Sample data generation
- Performance testing queries
- Backup and restore procedures
- Database monitoring setup
- Index optimization guide
- Query performance analysis
- Security configuration
```

---

## 🎨 **FASE 5: FRONTEND DEVELOPMENT**

### **Prompt 5.1: React Dashboard Application**
```
Actúa como senior frontend engineer especializado en developer tools UI. Necesito React application completa para CodeReviewer Pro dashboard.

CONTEXTO TÉCNICO:
- Framework: React 18 con TypeScript
- Styling: Tailwind CSS con custom design system
- State: Zustand para global state
- API: React Query para server state
- Router: React Router v6
- Build: Vite para fast development
- Deployment: Vercel

GENERA EXACTAMENTE:

1. **src/App.tsx** - Main application component:
   - Router setup con protected routes
   - Global providers (QueryClient, Auth, Theme)
   - Error boundary implementation
   - Loading states management
   - Toast notification system

2. **src/components/CodeEditor.tsx** - Code input component:
   - Monaco Editor integration
   - Syntax highlighting para multiple languages
   - Language detection
   - File upload capability
   - Code formatting options
   - Real-time validation

3. **src/components/ReviewDisplay.tsx** - Review results component:
   - Markdown rendering para reviews
   - Code diff highlighting
   - Expandable sections
   - Copy to clipboard functionality
   - Export options (PDF, Markdown)
   - Rating system para review quality

4. **src/pages/Dashboard.tsx** - Main dashboard:
   - Recent reviews list
   - Usage statistics charts
   - Quick actions panel
   - Performance metrics
   - Subscription status
   - Settings access

5. **src/services/api.ts** - API integration:
   - HTTP client setup con interceptors
   - Authentication token management
   - Error handling y retry logic
   - Request/response typing
   - API endpoints wrapper functions

6. **src/hooks/** - Custom React hooks:
   - useAuth() para authentication state
   - useReview() para review operations
   - useUsage() para usage statistics
   - useWebSocket() para real-time updates
   - useLocalStorage() para preferences

REQUERIMIENTOS ESPECÍFICOS:
- Responsive design (mobile, tablet, desktop)
- Dark/light theme support
- Accessibility compliance (WCAG 2.1)
- Performance optimization (code splitting, lazy loading)
- Error boundary con fallback UI
- Progressive Web App capabilities
- Offline support basics
- SEO optimization

INCLUDE:
- TypeScript configuration
- Tailwind CSS configuration
- ESLint and Prettier setup
- Testing setup con Jest + React Testing Library
- Storybook para component documentation
- Build optimization configuration
- Deployment scripts
- Performance monitoring setup
```

### **Prompt 5.2: VS Code Extension**
```
Actúa como VS Code extension developer. Necesito extension completa para integrar CodeReviewer Pro directamente en VS Code.

CONTEXTO:
- Platform: VS Code Extension API
- Language: TypeScript
- Features: Code review inline, sidebar panel, commands
- Integration: Con CodeReviewer Pro API
- Authentication: API key based
- UI: VS Code native components

GENERA EXACTAMENTE:

1. **src/extension.ts** - Main extension entry point:
   - activate() function con command registration
   - deactivate() cleanup function
   - Extension context management
   - Configuration loading
   - Event listeners setup

2. **src/reviewProvider.ts** - Core review functionality:
   - ReviewProvider class
   - analyzeCurrentFile() method
   - analyzeSelection() method
   - batchAnalyzeFiles() method
   - API communication logic
   - Error handling y user feedback

3. **src/webviewProvider.ts** - Review results panel:
   - WebviewViewProvider implementation
   - HTML/CSS para review display
   - Message passing entre webview y extension
   - Review history management
   - Export functionality

4. **src/decorationProvider.ts** - Inline annotations:
   - TextEditorDecorationType creation
   - Issue highlighting en code
   - Hover provider para detailed feedback
   - Quick fix suggestions
   - Severity indicators

5. **src/commands.ts** - Extension commands:
   - Review current file command
   - Review selection command
   - Review all files command
   - Configure API key command
   - Show review history command

6. **package.json** - Extension manifest:
   - Extension metadata y description
   - Commands contribution
   - Activation events
   - Configuration schema
   - Dependencies y scripts

REQUERIMIENTOS ESPECÍFICOS:
- Authentication flow para API key
- Progress indicators para long operations
- Caching para reviewed files
- Keyboard shortcuts
- Context menu integration
- Status bar integration
- Settings page para configuration
- Error reporting y logging

INCLUDE:
- Extension development setup
- Build y packaging scripts
- Testing framework setup
- Publication preparation
- Documentation para users
- Extension icon y assets
- Marketplace description
- Usage analytics setup
```

---

## 💰 **FASE 6: MONETIZATION & DEPLOYMENT**

### **Prompt 6.1: Subscription & Billing System**
```
Actúa como fintech engineer especializado en SaaS billing. Necesito sistema completo de subscriptions y billing para CodeReviewer Pro.

CONTEXTO:
- Payment processor: Stripe
- Tiers: Free (10 reviews/month), Pro ($19/month, 500 reviews), Team ($49/month, 2500 reviews)
- Features: Usage tracking, overage billing, subscription management
- Integration: FastAPI backend + React frontend

GENERA EXACTAMENTE:

1. **services/billing_service.py** - Core billing logic:
   - StripeService class con API integration
   - create_subscription(user_id, price_id)
   - update_subscription(subscription_id, new_price_id)
   - cancel_subscription(subscription_id, at_period_end=True)
   - handle_failed_payments(subscription_id)
   - calculate_usage_overages(user_id, billing_period)

2. **routers/billing.py** - Billing API endpoints:
   - POST /api/v1/billing/subscribe
   - POST /api/v1/billing/change-plan
   - POST /api/v1/billing/cancel
   - GET /api/v1/billing/invoices
   - POST /api/v1/billing/webhooks/stripe
   - GET /api/v1/billing/usage

3. **models/billing.py** - Billing database models:
   - Subscription model con Stripe integration
   - Invoice model para billing history
   - UsageRecord model para tracking
   - PaymentMethod model
   - BillingAddress model

4. **services/usage_tracker.py** - Usage monitoring:
   - track_api_usage(user_id, endpoint, tokens_used)
   - check_usage_limits(user_id)
   - calculate_monthly_usage(user_id, month)
   - send_usage_alerts(user_id, percentage_used)
   - reset_monthly_counters()

5. **frontend/components/BillingDashboard.tsx** - Frontend billing UI:
   - Current subscription display
   - Usage meters y charts
   - Upgrade/downgrade flows
   - Payment method management
   - Invoice history
   - Usage alerts

REQUERIMIENTOS ESPECÍFICOS:
- Stripe webhook handling para real-time updates
- PCI compliance considerations
- Prorated billing calculations
- Failed payment retry logic
- Cancellation flow con retention offers
- Usage analytics y reporting
- Tax calculation integration
- Multi-currency support preparation

INCLUDE:
- Stripe configuration setup
- Webhook signature verification
- Database migration para billing tables
- Frontend payment forms
- Testing con Stripe test environment
- Billing reconciliation scripts
- Customer support tools
- Compliance documentation
```

### **Prompt 6.2: Production Deployment System**
```
Actúa como DevOps engineer especializado en ML model deployment. Necesito deployment completo para CodeReviewer Pro en production.

CONTEXTO:
- Architecture: Microservices con Docker
- Cloud: Start con Railway/Vercel, scale a AWS/GCP
- Model: HuggingFace Spaces para model hosting
- Database: Managed PostgreSQL + Redis
- Monitoring: Logging, metrics, alerting
- CI/CD: GitHub Actions

GENERA EXACTAMENTE:

1. **docker/Dockerfile.api** - API service container:
   - Multi-stage build para optimization
   - Python dependencies installation
   - Security hardening
   - Health check implementation
   - Non-root user setup
   - Environment configuration

2. **docker/Dockerfile.frontend** - Frontend container:
   - Node.js build environment
   - Static asset optimization
   - Nginx configuration para serving
   - Gzip compression setup
   - Security headers configuration

3. **docker-compose.prod.yml** - Production composition:
   - API service configuration
   - Database service setup
   - Redis service setup
   - Nginx reverse proxy
   - Volume management
   - Network configuration

4. **.github/workflows/deploy.yml** - CI/CD pipeline:
   - Automated testing on PR
   - Docker image building
   - Security scanning
   - Deployment to staging
   - Production deployment con approval
   - Rollback capability

5. **infrastructure/railway.toml** - Railway deployment config:
   - Service definitions
   - Environment variables
   - Database connections
   - Domain configuration
   - Scaling parameters

6. **monitoring/logging.py** - Comprehensive logging:
   - Structured logging setup
   - Request/response logging
   - Error tracking con Sentry
   - Performance metrics
   - User analytics
   - Model performance monitoring

REQUERIMIENTOS ESPECÍFICOS:
- Zero-downtime deployment
- Automated database migrations
- Health checks y readiness probes
- Auto-scaling configuration
- Backup y disaster recovery
- Security monitoring
- Performance optimization
- Cost monitoring y alerts

INCLUDE:
- Environment configuration templates
- Database backup scripts
- Monitoring dashboard setup
- Alerting rules configuration
- Security scanning setup
- Performance testing scripts
- Deployment runbooks
- Incident response procedures
```

---

## ✅ **EXECUTION CHECKLIST**

### **Orden de Ejecución Recomendado:**
```
SEMANA 1-2: Prompts 1.1, 1.2 (Setup completo)
SEMANA 3-4: Prompts 2.1, 2.2, 2.3 (Data collection)
SEMANA 5-6: Prompts 3.1, 3.2 (Model training)
SEMANA 7-8: Prompts 4.1, 4.2 (Backend API)
SEMANA 9-10: Prompts 5.1, 5.2 (Frontend + Extension)
SEMANA 11-12: Prompts 6.1, 6.2 (Monetization + Deployment)
```

### **Validation Steps After Each Prompt:**
- [ ] Code runs without errors
- [ ] All tests pass
- [ ] Documentation is clear
- [ ] Performance meets requirements
- [ ] Security considerations addressed

### **Success Metrics:**
- [ ] 15K+ training examples collected
- [ ] Model achieves >85% review quality score
- [ ] API responds in <30 seconds
- [ ] Frontend loads in <3 seconds
- [ ] Extension installs and works correctly
- [ ] Payment system processes correctly

**¿Quieres que ejecutemos el primer prompt para empezar? 🚀**
