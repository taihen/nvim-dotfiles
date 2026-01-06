-- LSP server configurations and schemas for infrastructure/platform engineering
local M = {}

-- LSP server configurations
M.servers = {
    ansiblels = {},
    bashls = {
        filetypes = { "bash", "sh" },
    },
    dockerls = {},
    docker_compose_language_service = {},
    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                experimentalPostfixCompletions = true,
                staticcheck = true,
                usePlaceholders = true,
            },
        },
    },
    terraformls = {
        settings = {
            ["terraform-ls"] = {
                experimentalFeatures = {
                    prefillRequiredFields = true,
                },
            },
        },
    },
    helm_ls = {},
    lua_ls = {
        settings = {
            Lua = {
                completion = { callSnippet = "Replace" },
                diagnostics = { disable = { "missing-fields" } },
            },
        },
    },
    yamlls = {
        settings = {
            yaml = {
                hover = true,
                completion = true,
                validate = true,
                schemaStore = {
                    enable = false,
                    url = "",
                },
                trace = { server = "verbose" },
                -- Custom YAML schemas for infrastructure development
                schemas = require("schemastore").yaml.schemas({
                    extra = {
                        -- ArgoCD Application resources
                        {
                            description = "ArgoCD Application",
                            name = "argocd-application.json",
                            url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
                            fileMatch = {
                                "apps/ApplicationClusterStack.yaml",
                                "apps.yaml",
                                "**/argocd/**/application*.yaml",
                                "**/argocd/**/Application*.yaml",
                            },
                        },
                        -- ArgoCD ApplicationSet resources
                        {
                            description = "ArgoCD ApplicationSet",
                            name = "argocd-applicationset.json",
                            url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/applicationset_v1alpha1.json",
                            fileMatch = {
                                "ApplicationSet.yaml",
                                "**/argocd/**/applicationset*.yaml",
                                "**/argocd/**/ApplicationSet*.yaml",
                            },
                        },
                        -- ArgoCD AppProject resources
                        {
                            description = "ArgoCD AppProject",
                            name = "argocd-appproject.json",
                            url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/appproject_v1alpha1.json",
                            fileMatch = {
                                "**/argocd/**/appproject*.yaml",
                                "**/argocd/**/AppProject*.yaml",
                            },
                        },
                        -- Kustomization (Kustomize)
                        {
                            description = "Kustomize kustomization.yaml",
                            name = "kustomization.json",
                            url = "https://json.schemastore.org/kustomization.json",
                            fileMatch = {
                                "kustomization.yaml",
                                "kustomization.yml",
                            },
                        },
                        -- Flux Kustomization CRD
                        {
                            description = "Flux Kustomization",
                            name = "flux-kustomization.json",
                            url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/kustomize.toolkit.fluxcd.io/kustomization_v1.json",
                            fileMatch = {
                                "**/flux/**/kustomization*.yaml",
                                "**/flux-system/kustomization.yaml",
                            },
                        },
                        -- Flux HelmRelease CRD
                        {
                            description = "Flux HelmRelease",
                            name = "flux-helmrelease.json",
                            url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/helm.toolkit.fluxcd.io/helmrelease_v2beta1.json",
                            fileMatch = {
                                "**/flux/**/helmrelease*.yaml",
                                "**/flux/**/HelmRelease*.yaml",
                            },
                        },
                        -- Ansible playbooks
                        {
                            description = "Ansible Playbook",
                            name = "ansible-playbook.json",
                            url = "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json",
                            fileMatch = {
                                "**/playbooks/**/*.yaml",
                                "**/playbooks/**/*.yml",
                                "playbook*.yaml",
                                "playbook*.yml",
                                "site.yaml",
                                "site.yml",
                            },
                        },
                        -- Ansible tasks
                        {
                            description = "Ansible Tasks",
                            name = "ansible-tasks.json",
                            url = "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json",
                            fileMatch = {
                                "**/tasks/**/*.yaml",
                                "**/tasks/**/*.yml",
                                "**/handlers/**/*.yaml",
                                "**/handlers/**/*.yml",
                            },
                        },
                        -- Renovate configuration
                        {
                            description = "Renovate Config",
                            name = "renovate.json",
                            url = "https://docs.renovatebot.com/renovate-schema.json",
                            fileMatch = {
                                "renovate.json",
                                ".renovaterc",
                                ".renovaterc.json",
                            },
                        },
                        -- Dependabot configuration
                        {
                            description = "Dependabot Config",
                            name = "dependabot.json",
                            url = "https://json.schemastore.org/dependabot-2.0.json",
                            fileMatch = {
                                ".github/dependabot.yaml",
                                ".github/dependabot.yml",
                            },
                        },
                        -- GitHub Actions workflows
                        {
                            description = "GitHub Workflow",
                            name = "github-workflow.json",
                            url = "https://json.schemastore.org/github-workflow.json",
                            fileMatch = {
                                ".github/workflows/*.yaml",
                                ".github/workflows/*.yml",
                            },
                        },
                        -- GitLab CI
                        {
                            description = "GitLab CI",
                            name = "gitlab-ci.json",
                            url = "https://json.schemastore.org/gitlab-ci.json",
                            fileMatch = {
                                ".gitlab-ci.yaml",
                                ".gitlab-ci.yml",
                                "**/.gitlab/**/*.yaml",
                                "**/.gitlab/**/*.yml",
                            },
                        },
                        -- Docker Compose
                        {
                            description = "Docker Compose",
                            name = "docker-compose.json",
                            url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
                            fileMatch = {
                                "docker-compose*.yaml",
                                "docker-compose*.yml",
                                "compose*.yaml",
                                "compose*.yml",
                            },
                        },
                        -- Helm Chart.yaml
                        {
                            description = "Helm Chart",
                            name = "chart.json",
                            url = "https://json.schemastore.org/chart.json",
                            fileMatch = {
                                "Chart.yaml",
                                "Chart.yml",
                            },
                        },
                        -- Kubernetes resources (generic CRD catalog)
                        {
                            description = "Kubernetes",
                            name = "kubernetes.json",
                            url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json",
                            fileMatch = {
                                "**/k8s/**/*.yaml",
                                "**/k8s/**/*.yml",
                                "**/kubernetes/**/*.yaml",
                                "**/kubernetes/**/*.yml",
                                "**/manifests/**/*.yaml",
                                "**/manifests/**/*.yml",
                            },
                        },
                    },
                }),
            },
        },
    },
    jsonls = {
        settings = {
            json = {
                -- Custom JSON schemas for infrastructure development
                schemas = require("schemastore").json.schemas({
                    extra = {
                        -- Terraform variables and outputs
                        {
                            description = "Terraform tfvars",
                            name = "terraform-vars.json",
                            fileMatch = { "*.tfvars.json" },
                            url = "https://json.schemastore.org/terraform-vars.json",
                        },
                        -- AWS CloudFormation
                        {
                            description = "AWS CloudFormation",
                            name = "cloudformation.json",
                            fileMatch = {
                                "*.cf.json",
                                "cloudformation/*.json",
                                "**/cloudformation/**/*.json",
                            },
                            url = "https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json",
                        },
                        -- AWS SAM
                        {
                            description = "AWS SAM",
                            name = "sam.json",
                            fileMatch = {
                                "sam.json",
                                "template.json",
                                "**/sam/**/*.json",
                            },
                            url = "https://raw.githubusercontent.com/awslabs/goformation/master/schema/sam.schema.json",
                        },
                        -- Ansible inventory
                        {
                            description = "Ansible Inventory",
                            name = "ansible-inventory.json",
                            fileMatch = {
                                "**/inventory/**/*.json",
                                "inventory.json",
                                "hosts.json",
                            },
                            url = "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json",
                        },
                        -- ESLint
                        {
                            description = "ESLint",
                            name = "eslintrc.json",
                            fileMatch = {
                                ".eslintrc",
                                ".eslintrc.json",
                            },
                            url = "https://json.schemastore.org/eslintrc.json",
                        },
                        -- Prettier
                        {
                            description = "Prettier",
                            name = "prettierrc.json",
                            fileMatch = {
                                ".prettierrc",
                                ".prettierrc.json",
                                "prettier.config.json",
                            },
                            url = "https://json.schemastore.org/prettierrc.json",
                        },
                    },
                }),
                validate = { enable = true },
                format = { enable = true },
            },
        },
    },
}

-- Tools to ensure are installed via mason-tool-installer
M.ensure_installed = {
    "bashls",
    "black",
    "editorconfig-checker",
    "gofumpt",
    "goimports-reviser",
    "golines",
    "gopls",
    "isort",
    "jsonls",
    "lua_ls",
    "marksman",
    "prettier",
    "stylua",
    "taplo",
    "terraformls",
    "tflint",
    "trivy",
    "vale",
    "yamlfmt",
    "yamlls",
    "yq",
}

return M
