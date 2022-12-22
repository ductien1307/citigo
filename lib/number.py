from decimal import Decimal, ROUND_HALF_UP

__all__ = ['round_up']

def round_up(given_nb, float_nb=2):
    nb = Decimal(given_nb)
    f = "."
    for _ in range(int(float_nb) - 1):
        f += "0"
    f += "1"
    return nb.quantize(Decimal(f), rounding=ROUND_HALF_UP)
