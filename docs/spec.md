# DAC digital block: spec (draft)

## Assumptions (to confirm with analog team)
- DAC width: 8 bit, unsigned
- Reset output: 0x00 (or mid-scale 0x80)
- Enable/power-down: yes/no
- SPI mode 0, MSB first, 16-bit frame

## Pins
| Name | Dir | Width | Description |
|------|-----|-------|-------------|
| clk | in | 1 | chip clock |
| rst_n | in | 1 | async reset, active low |
| sclk, cs_n, mosi | in | 1 | SPI |
| miso | out | 1 | SPI |
| dac_code | out | 8 | to R2R ladder switches |

## Register map
| Addr | Name | Bits | Reset | Access | Description |
|------|------|------|-------|--------|-------------|
| 0x00 | DAC_CODE | [7:0] | 0x00 | R/W | DAC output code |
| 0x01 | CTRL | [0] EN | 0 | R/W | 1 = output enabled |
| 0x03 | ID | [7:0] | 0xA5 | R | fixed ID, link check |

## Open questions
(copy from issue #5)