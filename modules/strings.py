import unicodedata2


def normalizar_strings(nome):
    sem_espaco = nome.replace(" ","_").upper()
    normalizado = unicodedata2.normalize("NFD",sem_espaco)
    bytes = normalizado.encode("ascii","ignore")
    sem_acento = bytes.decode("utf-8")
    return sem_acento