# ATRIUM — Gestão de Demandas Imobiliárias
**Beyonder 2026 · Stable Release v1.0**

## O que é este sistema
Kanban de gestão de demandas para equipe imobiliária. Usuários cadastrados podem criar, atribuir e acompanhar tarefas ("demandas") em colunas estilo Trello: A Fazer → Em Andamento → Revisão → Concluído. Inclui analytics, perfis de usuário com foto, comentários por card e sugestão via IA (Anthropic Claude).

## Stack técnica
- **Frontend:** HTML5 + CSS3 + Vanilla JS (sem framework, sem build step)
- **Backend:** Supabase (PostgreSQL + Auth + Storage)
- **Libs:** SortableJS 1.15.2 (drag-and-drop), Supabase JS v2 (CDN)
- **Deploy:** Vercel — arquivos estáticos, zero build

## Arquivos principais
| Arquivo | Conteúdo |
|---------|----------|
| `index.html` | Toda a UI, lógica JS, SQL do wizard de setup (~2400 linhas) |
| `style.css` | Design system completo, tokens dark/light, mobile (~1260 linhas) |
| `vercel.json` | Rewrites de URL para SPA |

## Banco de dados (Supabase)
Tabelas criadas pelo SQL wizard integrado ao app:
- `profiles` — id, name, role (admin/gerente/corretor), color, avatar_url
- `cards` — title, description, status, urgency, assignee_id, co_assignee_ids[], deadline, created_by
- `comments` — card_id, user_id, body
- Storage bucket `avatars` — público, criado pelo próprio SQL do wizard

## Avatar / Foto de perfil
**Fluxo completo:**
1. Usuário seleciona arquivo → `handleProfilePic()`
2. Resize canvas 200×200 → base64 WebP (fallback JPEG)
3. Salva imediato em `localStorage['atrium_av_{userId}']`
4. Atualiza UI (sidebar + settings page)
5. Se base64 ≤ 512KB → salva em `profiles.avatar_url` no DB
6. Se maior → upload para bucket `avatars/{userId}/avatar.ext` → salva URL pública no DB
7. `saveProfile()` salva **apenas** name + role (avatar é independente)

## Mobile
- Sidebar → bottom navigation bar (60px + safe-area)
- Topbar → 2 linhas: título | busca + botão nova demanda
- Filter selects escondidos no mobile (cramped)
- Toast de notificação: `bottom: calc(68px + env(safe-area-inset-bottom))`
- Logout mobile: botão em Config → seção "Conta" (classe `mobile-only-logout`)
- Drawer → bottom sheet (92svh)
- Colunas kanban → horizontal scroll-snap

## Z-index stack
| Valor | Elemento |
|-------|---------|
| 9999 | Splash screen (pointer-events:none) |
| 9998 | Loading screen |
| 9997 | Toast de notificação |
| 8000 | Welcome overlay |
| 600 | FAB WhatsApp |
| 400 | Modal overlay (convidar membro) |
| 300 | Drawer overlay (card) |
| 200 | Drawer (mobile bottom sheet) |
| 100 | Sidebar mobile (bottom nav) |

## Regras de desenvolvimento
- **Jamais usar framework** — vanilla JS puro
- **Editar apenas** `index.html` e `style.css` — não criar arquivos desnecessários
- **CSS tokens:** usar `var(--accent)`, `var(--label)`, etc. — não hardcodar cores
- **Não sobrepor elementos:** respeitar z-index stack acima
- **Mobile first mindset:** testar todas as alterações em viewport 375px
- **Supabase:** anon key no client é correto (protegido por RLS); nunca expor service_role key
