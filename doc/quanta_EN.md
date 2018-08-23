# quanta

## Instruction set architecture

### Instruction types

#### Immediate

Single source/destination register address and immediate instruction.

**Syntax:** `OP \$r, imm`

#### Single Register

Single source/destination register address instruction.

**Syntax:** `OP \$r`

#### Double Register

Single source/destination register address and source register address instruction.

**Syntax:** `OP \$r, $s`

#### Triple Register

Double source register address and jump register address instruction.

**Syntax:** `OP \$r, $s, \$t`

#### Jump

Single jump address register instruction.

**Syntax:** `OP $r`

#### Call and link

Single link register address and jump register address instruction.

**Syntax:** `OP \$r, $s`

## Toolkit

### Assembler

#### Extended instruction types

Instruction types provided by the extended assembler. Translates to multiple assembly instructions.

##### Jump label

Single jump label instruction.

Translates to a load immediate storing the label address to \$31, followed by a jump to \$31.

**Syntax:** `OP label`

##### Double register label

Double source register address and jump label instruction.

Translates to a load immediate storing the label address to \$31, followed by a triple register instruction with jump register address \$31.

**Syntax:** `OP \$r, \$t, label`

##### Call label and link

Single link register address and jump label instruction.

Translates to a load immediate storing the label address to \$31, followed by a call instruction with jump register address \$31.

**Syntax:** `OP \$r, label`

#### Register aliases

Register names provided by the extended assembler for special purpose registers. Translates to register address.

| Label   | Address | Description                                |
| :------ | :------ | :----------------------------------------- |
| `$zero` | `$0`    | Hard wired zero register.                  |
| `$ra`   | `$30`   | Link register for call label instructions. |
| `$a`    | `$31`   | Reserved for the assembler.                |