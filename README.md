# 🔢 Number Base Converter (8086 Assembly)

Projeto de Exame – Sistemas Digitais II  
Curso de Engenharia Informática  
Universidade Católica de Angola (UCAN)  
#

Este repositório contém um conversor de bases numéricas desenvolvido em **Assembly x86** para o processador **Intel 8086**. O projeto foca-se na manipulação de dados a baixo nível, demonstrando como o hardware processa e traduz informações entre o utilizador e o CPU.

## 🚀 Funcionalidades
* **Conversão Dinâmica:** Suporta entradas decimais (0-65.535) e converte para Binário e Hexadecimal.
* **Manipulação de Bits:** Implementação de algoritmos de conversão via deslocamentos lógicos (`SHL`) e rotações (`ROL`).
* **Gestão de Buffer:** Leitura estruturada de teclado utilizando interrupções do MS-DOS (`INT 21h`).
* **Arquitetura 16-bit:** Uso eficiente dos registadores de uso geral e da pilha (Stack).

## 🛠️ Tecnologias e Ferramentas
* **Linguagem:** Assembly x86 (Sintaxe Intel).
* **Arquitetura-alvo:** Intel 8086 (Modo Real).
* **Emulador:** [emu8086](https://emu8086-microprocessor-emulator.en.softonic.com/).
* **Ambiente:** MS-DOS.

## 🧠 Conceitos Implementados
1. **Parsing ASCII:** Conversão de strings de entrada para valores binários puros.
2. **LIFO Stack:** Uso da pilha para inverter a ordem de dígitos na exibição decimal.
3. **Carry Flag:** Verificação de estados de bit através de rotações de registadores.
4. **Modularização:** Divisão do código em sub-rotinas (`PROC`) para fácil manutenção.

## 📂 Como Executar
1. Instale o emulador **emu8086**.
2. Abra o ficheiro `.asm` presente neste repositório.
3. Clique em **Emulate** e depois em **Run**.
4. Siga as instruções na consola para inserir o número e escolher a base.

---
Desenvolvido para fins académicos na cadeira de Sistemas Digitais
