# Evasão do curso de Ciência da Computação da UFRRJ - DCC-IM
Dataset construído com os históricos dos discentes do curso. A matrícula dos discentes foi substituída por um valor inteiro que identifique o discente de forma única.

## Scripts em R
Há uma sequência de execução dos scripts do R, seguindo a seguinte ordem:

1. **`script-1-distribuicao-periodos.R`**: Gera a distribuição dos discentes de acordo com o status ao longo dos anos.
2. **`script-2-modelo-sobrevivencia-entradas-evasao-modelo-Kapler-Meier-n-parametrico.R`**: Gera o modelo Kapler-Meier não paramétrico, inclusive com os gráficos de sobrevivência e risco relacionado ao modelo.
3. **`script-3-modelo-sobrevivencia-parametrico-evasao.R`**: Obtem 4 modelos paramétricos (Weibull, Exponencial e Lognormal), faz os testes dos modelos para verificar qual deles apresenta o menor valor para colocar no artigo.
4. **`script-4-funcoes-parametricas.R`**: Com base no modelo paramétrico escolhido no script anterior, constrói a curva para entender o comportamento da sobrevivência. Embora o gráfico não tenha sido colocado no artigo, os resultados numéricos foram importantes para embasar os resultados alcançados.

## Dataset
O dataset utilizado no trabalho é identificado pelo arquivo: ***discentes.csv***

Atributos do dataset e seu significado:
 - **`matricula`**: Atributo que identifica de forma única cada discente. As matrículas reais foram substituidas por valores inteiros para evitar eventual identificação.
 - **`dataNascimento`**: Data de nascimento do discente.
 - **`IRA`**: Coeficiente de rendimento dos discentes, campo do tipo ponto flutuante.
 - **`curriculo`**: indica o curriculo do discente. Apesar do dataset conter mais de dois curriculos, no artigo e estudo foram utilizados apenas dois, conformne descrito no artigo. A retirada dos discentes foi feita no script.
 - **`anoPeriodoLetivoInicial`**: Ano e período de ingresso dos discentes.
 - **`formaIngresso`**: forma de ingresso, majoritariamente a entrada é pelo ENEM.
 - **`periodoLetivoAtual`**: indica a quantiade de perídos que o discente cursou. A saída pode ocorrer pela conclusão, abandono ou desistência. Campo do tipo interio.
 - **`suspensoes`**: campo inteiro que indica quantos períodos o discente trancou.
 - **`prorrogacoes`**: quantidade de prorrogações que o discente solicita após o tempo regular do curso.
 - **`tipoSaida`**: indica qual foi a saída do discente. É redudante com a situação.
 - **`idade`**: valor inteiro que indica a idade do discente.
 - **`situacao`**: indica um das situações do discente:
   - ATIVO: Discente que está cursando  as disciplinas sem problemas.
   - CONCLUIDO: Discentes que terminaram e concluiram o curso
   - EVADIDO: Discentes que sairam do curso, ou por desligamento por ultrapassar o tempo máximo de integralização ou por que desistiu do curso. Qualquer desligamneto do curso.
    - TRANCADO: Discente que estão com o curso trancado no momento da construção do dataset
 - **`sucesso`**: Quantidade de componentes curriculares que o discente foi aprovado.
 - **`insucesso`**: Quantidade de componentes curriculares que o discente perdeu/reprovou.
 - **`total`**: sucesso + insucesso

O arquivo: tabelas-por-ppc.csv é criado no script: ***script-2-modelo-sobrevivencia-entradas-evasao-modelo-Kapler-Meier-n-parametrico.R*** e gera a tabela utilizada no artigo.
