A linguagem assembly aceita pelo processador é baseada na linguagem assembly MIPS, com pequenas alterações. O guia para programadores familiares com MIPS é uma forma rápida de aprender a linguagem. O guia completo é destinado a programadores com pouca ou nenhuma familiaridade com assembly ou programação em si.

### Guia para programadores MIPS

Na arquitetura quanta, um dos registradores de cada instrução é usado como registrador de origem e destino. Instruções que em MIPS seriam escritas como `INSTRUÇÃO $destino, $origem, $origem`  passam a ser escritas da forma mais compacta (a custo de poucas limitações) `INSTRUÇÃO $destino/origem, $origem`.

Instruções de acesso à memória não tem suporte a indexação, e o endereço de escrita na memória de dados é utilizado diretamente do registrador indicado, fornecendo até $2^{32}$ endereços para leitura/escrita de palavras de 32 bits. A manipulação da memória de dados cabe totalmente ao programador, incluindo conceitos como o ponteiro de stack (geralmente definido por conveniência como um endereço específico salvo em um registrador fixo).

### Guia completo

Cada instrução binária suportada pelo processador é escrita na forma de uma palavra binária de 32 bits, sendo os 8 primeiros reservados para o identificador da operação. As instruções operam em registradores de 32 bits, realizando testes ou modificações e salvando ou não o resultado.

#### Immediates

Todos os registradores são inicializados com o valor 0, e não podem ser manipulados diretamente. Instruções do tipo immediate são instruções que carregam na palavra de instrução um valor relevante. A inicialização dos registradores é feita por meio de instruções load immediate** (`li`).

Ao final da execução de uma instrução load immediate, o registrador de destino passa a armazenar o valor relevante (immediate).

Uma convenção útil (mas não obrigatória) é definir registradores de valores fixos e comumente usados no início do programa, com comentários correspondentes.

##### Blockly

O bloco correspondente a instruções do tipo immediate pode ser encontrado no menu de instruções. O código da instrução **load immediate** (`li`) pode ser selecionado no *dropdown* à esquerda do bloco. O slot **A** aceita um registrador de destino, e o slot **immediate** aceita um valor numérico a ser carregado.

![Definição de registradores comumente usados](C:\Projects\quanta\doc\res\RegistradoresPadrao.PNG)

#####Assembly

A sintaxe das instruções do tipo immediate em assembly é dada por `INSTRUÇÃO $destino, immediate`. O código da instrução é especificado por meio da palavra `li`, o endereço do registrador de destino é dado por um número logo após o `$`, e o valor a ser carregado é simplesmente um valor numérico inteiro.

`; Constante 0`
`li $0, 0`
`; Constante 1`
`li $1, 1`
`; Ponteiro da stack`
`li $29, 512`
`; Registrador de retorno`
`li $30, 0`

#### Operações simples

Os tipos mais intuitivos de operações assembly são operações matemáticas ou lógicas envolvendo dois registradores. Um dos registradores funciona como destino e origem de dados, enquanto o outro funciona como apenas origem. 

Usando como exemplo a instrução de **soma** (`add`), é possível especificar dois registradores que serão somados, sendo que o resultado será salvo no primeiro registrador (sobrescrevendo o valor inicial). O fato de que operações só podem ser realizadas entre dois registradores onde um deles é sobrescrito exige que o programador pense cuidadosamente na ordem de realização das operações, cuidando que agrupamentos com parênteses e precedência de operadores sejam respeitados.

Com o conhecimento de operações do tipo immediate e operações entre registradores, é possível escrever um programa completo que execute operações com valores numéricos inteiros. A expressão matemática $42 + 3 - (14 - 15)$ pode ser calculada por meio da seguinte sequência de instruções.

- Armazenar os valores correspondentes nos registradores
  - Carregar o valor 42 no registrador 0.
  - Carregar o valor 3 no registrador 1.
  - Carregar o valor 14 no registrador 2.
  - Carregar o valor 15 no registrador 3.
- Calcular o resultado da expressão entre parênteses $14 - 15 = -1$ (que será salva no registrador 2).
- Calcular o resultado da expressão $42 + 3 = 45$ (que será salva no registrador 0).
- Calcular o valor final da expressão $45 - 1 = 44$ (que será salvo no registrador 0).

##### Blockly

O bloco correspondente a instruções de operação em registradores pode ser encontrado no menu de instruções. O código da instrução pode ser selecionado no *dropdown* à esquerda do bloco, nesse exemplo **soma** (`add`) e **subtração** (`sub`). O slot **A** aceita um registrador de destino e origem, e o slot **B** aceita um registrador de origem.

![Exemplo do cálculo de uma expressão](C:\Projects\quanta\doc\res\ExemploSoma.PNG)

##### Assembly

A sintaxe das instruções de operação em registradores em assembly é dada por `INSTRUÇÃO $destino/origem, $origem`. O código da instrução é especificado por meio da palavra correspondente (`add` ou `sub` nesse exemplo), o endereço do registrador de destino/origem é dado por um número logo após o `$`, assim como o endereço do registrador de origem.

`; Calcular 42 + 3 - (14 - 15)`
`; Carregar os valores em registradores`
`li $0, 42`
`li $1, 3`
`li $2, 14`
`li $3, 15`
`; Calcular (14 - 15)`
`; Subtrai os registradores 2 e 3`
`; (e salva o resultado no registrador 2)`
`sub $2, $3`
`; Calcular 42 + 3`
`; Soma os registradores 0 e 1`
`; (e salva o resultado no registrador 0)`
`add $0, $1`
`; Calcular o valor final`
`; Subtrai os registradores 0 e 2`
`; (e salva o resultado no registrador 0)`
`sub $0, $2`

