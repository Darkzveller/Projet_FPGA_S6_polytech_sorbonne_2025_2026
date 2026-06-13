
# Entity: BANC_REGISTRE 
- **File**: banc_registre.vhd

## Diagram
![Diagram](BANC_REGISTRE.svg "Diagram")
## Ports

| Port name | Direction | Type                           | Description |
| --------- | --------- | ------------------------------ | ----------- |
| Clk       | in        | STD_LOGIC                      |             |
| Reset     | in        | STD_LOGIC                      |             |
| W         | in        | STD_LOGIC_VECTOR (31 downto 0) |             |
| RA        | in        | STD_LOGIC_VECTOR (3 downto 0)  |             |
| RB        | in        | STD_LOGIC_VECTOR (3 downto 0)  |             |
| RW        | in        | STD_LOGIC_VECTOR (3 downto 0)  |             |
| WE        | in        | STD_LOGIC                      |             |
| A         | out       | STD_LOGIC_VECTOR (31 downto 0) |             |
| B         | out       | STD_LOGIC_VECTOR (31 downto 0) |             |

## Signals

| Name | Type  | Description |
| ---- | ----- | ----------- |
| Banc | table |             |

## Types

| Name  | Type | Description |
| ----- | ---- | ----------- |
| table |      |             |

## Functions
- init_banc <font id="function_arguments">()</font> <font id="function_return">return table</font>

## Processes
- unnamed: ( Clk, Reset )
