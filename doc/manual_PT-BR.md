A linguagem assembly aceita pelo processador é baseada na linguagem assembly MIPS, com pequenas alterações. O guia para programadores familiares com MIPS é uma forma rápida de aprender a linguagem. O guia completo é destinado a programadores com pouca ou nenhuma familiaridade com assembly ou programação em si.

### Guia para programadores MIPS

Na arquitetura quanta, um dos registradores de cada instrução é usado como registrador de origem e destino. Instruções que em MIPS seriam escritas como `INSTRUÇÃO $destino, $origem, $origem`  passam a ser escritas da forma mais compacta (a custo de poucas limitações) `INSTRUÇÃO $destino/origem, $origem`.

Instruções de acesso à memória não tem suporte a indexação, e o endereço de escrita na memória de dados é utilizado diretamente do registrador indicado, fornecendo até $2^{32}$ endereços para leitura/escrita de palavras de 32 bits. A manipulação da memória de dados cabe totalmente ao programador, incluindo conceitos como o ponteiro de stack (geralmente definido por conveniência como um endereço específico salvo em um registrador fixo).

### Guia completo

Cada instrução binária suportada pelo processador é escrita na forma de uma palavra binária de 32 bits, sendo os 8 primeiros reservados para o identificador da operação. As instruções operam em registradores de 32 bits, realizando testes ou modificações e salvando ou não o resultado.

#### Immediates

Todos os registradores são inicializados com o valor 0, e não podem ser manipulados diretamente. Instruções do tipo immediate são instruções que carregam na palavra de instrução um valor relevante. A inicialização dos registradores é feita por meio de instruções **load immediate** (`li`).

Ao final da execução de uma instrução load immediate, o registrador de destino passa a armazenar o valor relevante (immediate).

Uma convenção útil (mas não obrigatória) é definir registradores de valores fixos e comumente usados no início do programa, com comentários correspondentes.

##### Blockly

O bloco correspondente a instruções do tipo immediate pode ser encontrado no menu de instruções. O código da instrução **load immediate** (`li`) pode ser selecionado no *dropdown* à esquerda do bloco. O slot **A** aceita um registrador de destino e o slot **immediate** aceita um valor numérico a ser carregado.

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

O bloco correspondente a instruções de operação em registradores pode ser encontrado no menu de instruções. O código da instrução pode ser selecionado no *dropdown* à esquerda do bloco, nesse exemplo **soma** (`add`) e **subtração** (`sub`). O slot **A** aceita um registrador de destino e origem e o slot **B** aceita um registrador de origem.

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

#### Copiando valores

As operações entre registradores sobrescrevem o valor do registrador de destino, mas muitas vezes o valor de um registrador precisa ser usado em mais de uma operação, e não pode ser perdido. Como não é possível realizar uma operação sem sobrescrever o registrador de destino, em certas circunstâncias é necessário fazer cópias dos valores de um registrador.

Considere por exemplo um programa que calcule o resultado da expressão $2 + 5$ e em seguida calcule o valor da expressão $2 + 4$. É conveniente e intuitivo executar apenas uma instrução **load immediate** com o valor 2, e utilizar o registrador de destino em ambas as operações. O problema surge quando a chamada de uma instrução de **soma** sobrescreveria o valor 2 no registrador.

A instrução **move** (`mov`) permite que o valor de um registrador de origem seja copiado para o registrador de destino. Utilizando instruções de cópia, a execução do programa acima pode ser feita por meio da seguinte sequência de instruções.

- Armazenar os valores correspondentes nos registradores
  - Carregar o valor 2 no registrador 0.
  - Carregar o valor 5 no registrador 1.
  - Carregar o valor 4 no registrador 2.
- Copiar o valor 2 para o registrador 3 antes que ele seja sobrescrito.
- Calcular o resultado da expressão $2 + 5 = 7$ (que será salva no registrador 0, sobrescrevendo o valor 2).
- Calcular o resultado da expressão $2 + 4 = 6$ utilizando a cópia do valor 2 (que será salvo no registrador 3).

##### Blockly

O bloco correspondente a instrução de cópia pode ser encontrado no menu de instruções. O código da instrução **move** (`mov`) pode ser selecionado no *dropdown* à esquerda do bloco. O slot **A** aceita um registrador de destino e o slot **B** aceita um registrador de origem (a ordem é importante).

![Exemplo de cópia de valores em registradores.](C:\Projects\quanta\doc\res\ExemploMove.PNG)

##### Assembly

A sintaxe da instrução de cópia de registradores em assembly é dada por `INSTRUÇÃO $destino, $origem`. O código da instrução é especificado por meio da palavra `mov`, o endereço do registrador de destino é dado por um número logo após o `$`, assim como o endereço do registrador de origem (a ordem é importante).

`; Carregar os valores em registradores`
`li $0, 2`
`li $1, 5`
`li $2, 4`
`; Copiar o registrador 0 para o registrador 3`
`mov $3, $0`
`; Calcular 2 + 5`
`add $0, ​$1`
`; Calcular 2 + 4`
`sub $3, $2`

#### Operações condicionais

Programas definidos por uma lista de valores e manipulações são limitados e capazes de executar apens da forma exata como foram escritos. Qualquer programa que espere resolver problemas mais complexos requer a capacidade de tomar decisões durante a execução do código, por exemplo reagir aos dados fornecidos por um usuário, ou aos próprios resultados obtidos durante sua execução.

Operações condicionais permitem que uma condição seja testada para dois registradores, e caso avaliada verdadeira, desviar a execução para outra parte do programa. Um dos exemplos de instrução condicional é a instrução **jump if not equals** (`jne`) que testa se o conteúdo de dois registradores é diferente, e caso seja, desvia a execução do programa para uma certa instrução específica.

O destino do desvio é marcado no código por meio de **labels**, uma palavra que identifique um certo ponto no código para onde a execução pode ser desviada.

Operações condicionais permitem a escrita de programas mais elaborados, como multiplicações por somas consecutivas. Por exemplo, uma operação de multiplicação $3 * 4 = 12$ pode ser escrita como uma soma consecutiva $4 + 4 + 4 = 12$ por meio da seguinte sequência de instruções.

- Armazenar os valores correspondentes nos registradores
  - Carregar o valor 0 no registrador 0.
  - Carregar o valor 1 no registrador 1.
  - Carregar o valor 3 no registrador 2.
  - Carregar o valor 4 no registrador 3.
- Definir uma label que marque o início do código para uma soma consecutiva.
- Somar o valor 4 no registrador escolhido para o resultado.
- Subtrair 1 do registrador 2.
- Comparar o registrador 2 com 0
  - Se o registrador 2 for igual a zero, todas as somas consecuitivas foram executadas.
  - Senão, desviar a execução para o início da soma consecutiva.

##### Blockly

O bloco correspondente a instrução de desvio condicional pode ser encontrado no menu de instruções. O código da instrução **jump if not equals** (`jne`) pode ser selecionado no *dropdown* à esquerda do bloco. Os slots **A** e **B** aceitam os registradores a serem comparados e o slot **C** aceita o destino do desvio caso a condição seja verificada.

Os blocos referentes a labels podem ser encontrados no meu de labels. Ao grupo de labels podem ser conectadas várias instruções que serão agrupadas e ao identificador de labels pode ser dado um nome (nesse caso igual ao do grupo) para uso como destino de desvio.

![Exemplo de multiplicação por somas consecutivas.](C:\Projects\quanta\doc\res\ExemploMul.PNG)

#####Assembly

A sintaxe da instrução de desvio em assembly é dada por `INSTRUÇÃO $origen, $origem, label`. O código da instrução é especificado por meio da palavra `jne`, os endereços do registradores de origem são dados pelos números logo após o `$` e o destino do desvio é dado por um identificador com o mesmo nome da label correspondente.

As labels que definem pontos específicos no código são compostas por um identificador seguido de `:`. Uma convenção útil (mas não obrigatória) é indentar todas as linhas abaixo de uma label com quatro espaços.

`; Carregar os valores em registradores`
`li $0, 0`
`li $1, 1`
`li $2, 3`
`li $3, 4`
`; Início de uma soma consecutiva`
`soma:`
      `; Somar 4 no resultado`
      `add $4, $3`
      `; Subtrair 1 do contador de somas`
      `sub $1, $2`
      `jne $2, $0, soma`

#### Subrotinas

Exemplos como o anterior mostram que partes de um programa podem ser reaproveitadas, simplificando a escrita de código. Por exemplo, o trecho responsável por multiplicar os registradores `$2` e `$3` e armazenar o resultado no registrador `$4` pode ser utilizado para qualquer multiplicação, desde que os valores sejam colocados nos registradores `$2`e `$3`.

O conceito de subrotinas torna esse tipo de modularização possível. Uma subrotina é definida por meio de uma label, e sua execução pode ser iniciada por meio de um jump para o endereço da label. Após a execução completa da subrotina, um jump para a instrução que estava sendo executada permite que o programa continue normalmente e acesse os valores calculados.

Para que a execução retorne exatamente ao ponto onde a subrotina foi chamada, é necessário salvar o endereço de origem da chamada. A instrução **call** (`call`) executa um jump ao mesmo tempo que salva o endereço da instrução de origem, permitindo que a execução retorne ao ponto inicial. O retorno ao ponto inicial é feito por meio de um desvio para o registrador escrito pela instrução call.

Como as instruções são executadas sequencialmente, após o final da rotina de multiplicação, quando a execução retorna ao ponto inicial, é importante desviar a execução para o final do programa, evitando que o código da subrotina seja executado sem a chamada.

##### Blockly

O bloco correspondente a instrução de chamada de subrotina pode ser encontrado no menu de instruções. O código da instrução **call** (`call`) pode ser selecionado no *dropdown* à esquerda do bloco. O slot **A** aceita o registrador de destino do endereço de retorno  e o slot **B** aceita a label que identifica a subrotina.

![Exemplo de subrotina de multiplicação.](C:\Projects\quanta\doc\res\ExemploSubrotina.PNG)

##### Assembly

A sintaxe da instrução de chamada de subrotina em assembly é dada por `INSTRUÇÃO $destino, label`. O código da instrução é especificado por meio da palavra `call`, o registrador destino do endereço de retorno é dado pelo número logo após o `$` e o nome da subrotina é dado por um identificador com o mesmo nome da label correspondente.

`; Carregar os valores em registradores`
`li $0, 0`
`li $1, 1`
`li $2, 3`
`li $3, 4`
`; Chamar subrotina de multiplicação`
`call $30, .mul`
`; Desviar para o final do programa`
`j end`
`; Multiplicação`
`mul:`
      `add $4, $3`
      `sub $2, $1`
      `jne $4, $0, .mul`
      `j $30`

`end:`
