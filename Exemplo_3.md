A empresa EduConnect é uma plataforma de ensino online que oferece cursos profissionalizantes, técnicos e preparatórios para concursos. A empresa trabalha com instrutores independentes e possui milhares de alunos cadastrados.

Cada curso pode conter múltiplos módulos, com vídeos, textos e atividades avaliativas. Os alunos acessam as aulas, realizam atividades, recebem notas e podem emitir certificados digitais ao final dos cursos concluídos com sucesso.

A EduConnect também precisa controlar a emissão de certificados, acompanhar a evolução dos alunos em cada curso, registrar feedbacks dos usuários sobre os conteúdos e manter um histórico completo das interações de aprendizado.

A equipe técnica da plataforma contratou você para projetar o banco de dados completo (em PostgreSQL), com foco em:

# Modelo Conceitual

## Entidades

- **Aluno**: representa os usuários que consomem os cursos.
- **Instrutor**: profissionais responsáveis pela criação dos cursos.
- **Curso**: conjunto de módulos, criado por um instrutor.
- **Módulo**: subdivisão de um curso, contendo conteúdos.
- **Conteúdo**: pode ser vídeo, texto ou atividade avaliativa.
- **Atividade**: tarefas avaliativas dentro dos módulos.
- **Certificado**: documento digital emitido ao aluno aprovado.
- **Feedback**: avaliações e comentários dos alunos sobre cursos.
- **Histórico de Progresso**: registro do avanço do aluno nos cursos.

## Relacionamentos

- Um **Instrutor** pode criar vários **Cursos**.
- Um **Curso** possui vários **Módulos**.
- Um **Módulo** possui vários **Conteúdos** (vídeo, texto, atividade).
- Um **Aluno** pode se inscrever em vários **Cursos**.
- Um **Aluno** pode realizar várias **Atividades** e receber **Notas**.
- Um **Aluno** pode emitir vários **Certificados** (um por curso concluído).
- Um **Aluno** pode deixar vários **Feedbacks** para cursos.
- O **Histórico de Progresso** relaciona **Alunos** e **Cursos**.

# Modelo Lógico (PostgreSQL)

## Tabelas e Relacionamentos

- **aluno** (id, nome, email, data_cadastro)
- **instrutor** (id, nome, email, bio)
- **curso** (id, titulo, descricao, instrutor_id)
- **modulo** (id, titulo, curso_id, ordem)
- **conteudo** (id, tipo, titulo, modulo_id, url_arquivo)
- **atividade** (id, conteudo_id, descricao, pontuacao_maxima)
- **inscricao** (id, aluno_id, curso_id, data_inscricao)
- **nota_atividade** (id, aluno_id, atividade_id, nota, data_realizacao)
- **certificado** (id, aluno_id, curso_id, data_emissao, codigo)
- **feedback** (id, aluno_id, curso_id, comentario, nota, data)
- **historico_progresso** (id, aluno_id, curso_id, modulo_id, status, data_atualizacao)

# Modelo Físico

### Scripts de Criação

```sql
-- Criação das tabelas (conforme já apresentado)
CREATE TABLE instrutor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    bio TEXT
);

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    instrutor_id INTEGER REFERENCES instrutor(id)
);

CREATE TABLE modulo (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    curso_id INTEGER REFERENCES curso(id),
    ordem INTEGER NOT NULL
);

CREATE TABLE conteudo (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL, -- 'video', 'texto', 'atividade'
    titulo VARCHAR(200) NOT NULL,
    modulo_id INTEGER REFERENCES modulo(id),
    url_arquivo VARCHAR(255)
);

CREATE TABLE atividade (
    id SERIAL PRIMARY KEY,
    conteudo_id INTEGER REFERENCES conteudo(id),
    descricao TEXT,
    pontuacao_maxima INTEGER NOT NULL
);

CREATE TABLE inscricao (
    id SERIAL PRIMARY KEY,
    aluno_id INTEGER REFERENCES aluno(id),
    curso_id INTEGER REFERENCES curso(id),
    data_inscricao DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE nota_atividade (
    id SERIAL PRIMARY KEY,
    aluno_id INTEGER REFERENCES aluno(id),
    atividade_id INTEGER REFERENCES atividade(id),
    nota NUMERIC(5,2),
    data_realizacao DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE certificado (
    id SERIAL PRIMARY KEY,
    aluno_id INTEGER REFERENCES aluno(id),
    curso_id INTEGER REFERENCES curso(id),
    data_emissao DATE NOT NULL DEFAULT CURRENT_DATE,
    codigo VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    aluno_id INTEGER REFERENCES aluno(id),
    curso_id INTEGER REFERENCES curso(id),
    comentario TEXT,
    nota INTEGER CHECK (nota >= 1 AND nota <= 5),
    data DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE historico_progresso (
    id SERIAL PRIMARY KEY,
    aluno_id INTEGER REFERENCES aluno(id),
    curso_id INTEGER REFERENCES curso(id),
    modulo_id INTEGER REFERENCES modulo(id),
    status VARCHAR(20) NOT NULL, -- 'em andamento', 'concluido'
    data_atualizacao DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Criação de índices para otimizar consultas
CREATE INDEX idx_instrutor_email ON instrutor(email);
CREATE INDEX idx_aluno_email ON aluno(email);
CREATE INDEX idx_curso_instrutor_id ON curso(instrutor_id);
CREATE INDEX idx_modulo_curso_id ON modulo(curso_id);
CREATE INDEX idx_conteudo_modulo_id ON conteudo(modulo_id);
CREATE INDEX idx_atividade_conteudo_id ON atividade(conteudo_id);
CREATE INDEX idx_inscricao_aluno_id ON inscricao(aluno_id);
CREATE INDEX idx_inscricao_curso_id ON inscricao(curso_id);
CREATE INDEX idx_nota_atividade_aluno_id ON nota_atividade(aluno_id);
CREATE INDEX idx_nota_atividade_atividade_id ON nota_atividade(atividade_id);
CREATE INDEX idx_certificado_aluno_id ON certificado(aluno_id);
CREATE INDEX idx_certificado_curso_id ON certificado(curso_id);
CREATE INDEX idx_feedback_aluno_id ON feedback(aluno_id);
CREATE INDEX idx_feedback_curso_id ON feedback(curso_id);
CREATE INDEX idx_historico_progresso_aluno_id ON historico_progresso(aluno_id);
CREATE INDEX idx_historico_progresso_curso_id ON historico_progresso(curso_id);
CREATE INDEX idx_historico_progresso_modulo_id ON historico_progresso(modulo_id);

-- Exemplo de criação de TABLESPACES (ajuste os nomes conforme necessário)
-- Primeiro, crie os tablespaces no PostgreSQL (com permissão de superusuário):
CREATE TABLESPACE ts_dados LOCATION '/mnt/postgres_data';
CREATE TABLESPACE ts_indices LOCATION '/mnt/postgres_indices';

-- Depois, associe as tabelas e índices aos tablespaces:
ALTER TABLE aluno SET TABLESPACE ts_dados;
ALTER TABLE instrutor SET TABLESPACE ts_dados;
ALTER TABLE curso SET TABLESPACE ts_dados;
ALTER TABLE modulo SET TABLESPACE ts_dados;
ALTER TABLE conteudo SET TABLESPACE ts_dados;
ALTER TABLE atividade SET TABLESPACE ts_dados;
ALTER TABLE inscricao SET TABLESPACE ts_dados;
ALTER TABLE nota_atividade SET TABLESPACE ts_dados;
ALTER TABLE certificado SET TABLESPACE ts_dados;
ALTER TABLE feedback SET TABLESPACE ts_dados;
ALTER TABLE historico_progresso SET TABLESPACE ts_dados;

ALTER INDEX idx_instrutor_email SET TABLESPACE ts_indices;
ALTER INDEX idx_aluno_email SET TABLESPACE ts_indices;
ALTER INDEX idx_curso_instrutor_id SET TABLESPACE ts_indices;
ALTER INDEX idx_modulo_curso_id SET TABLESPACE ts_indices;
ALTER INDEX idx_conteudo_modulo_id SET TABLESPACE ts_indices;
ALTER INDEX idx_atividade_conteudo_id SET TABLESPACE ts_indices;
ALTER INDEX idx_inscricao_aluno_id SET TABLESPACE ts_indices;
ALTER INDEX idx_inscricao_curso_id SET TABLESPACE ts_indices;
ALTER INDEX idx_nota_atividade_aluno_id SET TABLESPACE ts_indices;
ALTER INDEX idx_nota_atividade_atividade_id SET TABLESPACE ts_indices;
ALTER INDEX idx_certificado_aluno_id SET TABLESPACE ts_indices;
ALTER INDEX idx_certificado_curso_id SET TABLESPACE ts_indices;
ALTER INDEX idx_feedback_aluno_id SET TABLESPACE ts_indices;
ALTER INDEX idx_feedback_curso_id SET TABLESPACE ts_indices;
ALTER INDEX idx_historico_progresso_aluno_id SET TABLESPACE ts_indices;
ALTER INDEX idx_historico_progresso_curso_id SET TABLESPACE ts_indices;
ALTER INDEX idx_historico_progresso_modulo_id SET TABLESPACE ts_indices;
```
