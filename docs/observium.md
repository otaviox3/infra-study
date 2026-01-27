# Observium – Monitoramento de rede e servidores

**Autor:** Otávio Azevedo  

Este documento resume a minha experiência instalando e configurando o **Observium**
para monitorar switches, roteadores, firewalls e servidores (Linux/Windows) em ambiente
corporativo.

Não é um tutorial linha a linha, e sim um resumo técnico do que eu faço na prática:
instalação, descoberta de dispositivos, organização, gráficos e alertas básicos.

---

## 1. Cenário de uso

Uso o Observium principalmente para:

- visualizar **gráficos históricos** de:
  - uso de CPU, memória e disco em servidores;
  - tráfego em interfaces de rede (links, uplinks, VLANs);
- ter uma visão centralizada de:
  - quais hosts estão **UP/DOWN**;
  - interfaces que estão saturando ou com erros/discards;
- apoiar troubleshooting em:
  - quedas intermitentes;
  - suspeita de gargalo de banda;
  - crescimento de uso de disco.

Em geral, ele complementa ferramentas como **Zabbix**, focando mais em:

- gráficos SNMP detalhados;
- visão de infraestrutura de rede;
- inventário de interfaces e equipamentos.

---

## 2. Instalação (visão geral)

Normalmente instalo o Observium em um servidor Linux dedicado (geralmente Ubuntu/Debian),
com os seguintes componentes:

- Apache ou Nginx;
- PHP;
- MariaDB/MySQL;
- RRDTool, SNMP e dependências de gráficos.

Fluxo típico:

1. Preparar o sistema com pacotes base (web server, PHP, banco, SNMP).
2. Baixar o Observium (Community ou Professional, dependendo do ambiente).
3. Ajustar permissões da pasta do Observium.
4. Criar o banco de dados e usuário específicos do Observium.
5. Configurar o `config.php` com:
   - credenciais do banco;
   - diretórios de logs e RRD;
   - comunidade SNMP padrão;
   - timezone e ajustes gerais.
6. Criar o VirtualHost no Apache/Nginx para acessar via:
   - `http://observium.cobaia.exemplo.com/`
   - ou `https://observium.cobaia.exemplo.com/` (via proxy/SSL).

Depois disso, acesso a interface web, crio o usuário admin e começo a descoberta.

---

## 3. Configuração de SNMP nos dispositivos

Para o Observium funcionar bem, ativo e ajusto **SNMP** nos dispositivos monitorados:

- switches e roteadores;
- firewalls;
- servidores Linux e Windows (quando interessante).

Exemplos de boas práticas que costumo seguir:

- utilizar comunidades SNMP específicas por ambiente (ex.: produção vs. teste);
- restringir o acesso SNMP no firewall (apenas IP do servidor Observium);
- em Linux:
  - configurar `snmpd` para expor informações de CPU, memória, discos e interfaces;
- em Windows:
  - uso SNMP ou WMI, conforme a necessidade e política do ambiente.

---

## 4. Descoberta e adição de hosts

No Observium, existem dois modos principais que uso:

### 4.1. Adição manual de hosts

- Pelo terminal, usando comandos do tipo `./add_device.php` informando:
  - hostname ou IP;
  - comunidade SNMP;
  - versão do SNMP (v2c, por exemplo).

### 4.2. Descoberta automática (Discovery + Poller)

- Configuro ranges de rede no `config.php` e deixo que o Observium:
  - descubra hosts ativos;
  - identifique automaticamente o tipo de equipamento;
  - crie os gráficos e objetos internos.

Em ambos os casos, verifico na interface web se:

- as interfaces estão sendo mostradas corretamente;
- os gráficos começaram a ser gerados (após alguns ciclos de poller);
- o tipo de dispositivo e OS foram detectados corretamente.

---

## 5. Organização por grupos e categorias

Para o ambiente não virar um caos visual, organizo os hosts em:

- **Grupos lógicos**, por exemplo:
  - `Core`, `Distribuição`, `Acesso`;
  - `Servidores Linux`, `Servidores Windows`;
  - `Banco de dados`, `Aplicação`, `Monitoramento`.

- **Localizações**:
  - definido por site, cidade ou datacenter;
  - ajuda a entender problemas regionais (ex.: link de uma filial).

Isso facilita na hora de:

- filtrar telas;
- criar gráficos agregados por grupo;
- localizar rapidamente um host dentro da estrutura.

---

## 6. Gráficos e indicadores que acompanho

No dia a dia, os gráficos que mais olho são:

- **Interfaces de rede**:
  - tráfego (in/out);
  - erros e discards;
  - uso em porcentagem da capacidade do link;
- **CPU e memória** de servidores;
- **Uso de disco**:
  - crescimento ao longo do tempo;
  - identificação de partições críticas.

Esses gráficos ajudam a:

- justificar aumento de capacidade de link;
- entender quando um servidor está constantemente no limite;
- identificar padrões de uso em horários de pico.

---

## 7. Alertas e thresholds básicos

Embora o Observium não substitua o Zabbix em alertas complexos, uso alguns recursos de alerting:

- configuração de **alertas básicos** por:
  - alta utilização de interface por tempo prolongado;
  - queda de host (ping/SNMP);
  - uso de disco acima de determinada porcentagem.

Em geral:

- defino regras core para dispositivos críticos;
- aponto notificações para e-mail ou integração com outras ferramentas,
  dependendo do ambiente.

---

## 8. Integração com outras ferramentas

Em ambientes mais completos, o Observium convive com:

- **Zabbix** – responsável por alertas mais avançados, monitoramento de aplicações e triggers detalhadas;
- **Ferramentas de log/ELK/Graylog** – para correlacionar logs com quedas e gráficos;
- **Ferramentas de inventário/configuração** (como Ansible, CMDB, etc.).

O Observium entra como:

- uma visão de **saúde da rede e infraestrutura** via SNMP;
- um painel rápido para entender **links sobrecarregados** ou **interfaces com problemas**.

---

## 9. O que isso demonstra no meu perfil

Com essa experiência em Observium, eu demonstro:

- capacidade de instalar e configurar uma ferramenta de monitoramento SNMP em Linux;
- entendimento de como expor métricas via SNMP em switches, roteadores e servidores;
- organização de hosts por grupos, localizações e tipo de dispositivo;
- leitura e interpretação de gráficos de desempenho (CPU, memória, disco, tráfego);
- configuração de alertas básicos para acompanhar recursos críticos;
- integração conceitual com outras ferramentas de monitoramento e logging (como Zabbix).

Este documento funciona como um resumo do que eu já fiz com Observium em produção
e complementa outros tópicos do repositório **infra-study** (Zabbix, servidores Linux,
balanceadores, etc.).
