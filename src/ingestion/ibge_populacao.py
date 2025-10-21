from modules.sidrapy_requests import sidrapy_populacao



genero = {'2':'4,5'}
idade1 = {'287':'93070,93084,93085,93086,93087,93088,93089,93090'}
idade2 = {'287':'93091,93092,93093,93094,93095,93096,93097,93098'}
idade3 = {'287':'49108,49109,60040,60041,6653'}
forma_abastecimento = {'301':'31471,72054,72055,72088,31472,72089,72090,72091'}
existencia_canalizacao = {'1817':'72126,72127,72128'}
destino_lixo = {'67':'2520,72120,72121,72122,72123,72124,1091'}
rendimento_medio1 = {'11913':'31721,31722,31723,31724,79367,79368,79369'}
rendimento_medio2 = {'11913':'31727,79370,79371,79372,79373,79374,79375'}
rendimento_medio3 = {'11913':'79376,79377,45934,45935,45936,45937'}
alfabetizadas = {'59':'1023,1024'}


#População residente, Variação absoluta de população residente e Taxa de crescimento geométrico
sidrapy_populacao("populacao_2022","4709","6","93","all","AM",[5,6,4,10],None)

#População Residente, Área territorial e Densidade demográfica
sidrapy_populacao("densidade_demografica_2022","4714","6","614","all","AM",[5,6,4,10],None)

#População residente, por sexo, idade e forma de declaração da idade
sidrapy_populacao('genero_2022','9514','6','93','all','AM',[5,6,12,10,4],genero)
sidrapy_populacao('faixa_etaria1_2022','9514','6','93','all','AM',[5,6,12,10,4],idade1)
sidrapy_populacao('faixa_etaria2_2022','9514','6','93','all','AM',[5,6,12,10,4],idade2)
sidrapy_populacao('faixa_etaria3_2022','9514','6','93','all','AM',[5,6,12,10,4],idade3)

#Domicílios particulares permanentes ocupados, por existência de canalização de água e principal forma de abastecimento de água
sidrapy_populacao('forma_abastecimento_2022','6804','6','381','all','AM',[5,6,12,10,4],forma_abastecimento)
sidrapy_populacao('existencia_canalizacao_2022','6804','6','381','all','AM',[5,6,12,10,4],existencia_canalizacao)

#Domicílios particulares permanentes ocupados, por destino do lixo
sidrapy_populacao('destino_lixo_2022','6892','6','381','all','AM',[5,6,12,10,4],destino_lixo)

#Valor do rendimento nominal médio mensal de todos os trabalhos das pessoas de 14 anos ou mais de idade, ocupadas na semana de referência, com rendimento de trabalho (Reais)
sidrapy_populacao('rendimento_medio1_2022','10280','6','13536','all','AM',[5,6,12,10,4],rendimento_medio1)
sidrapy_populacao('rendimento_medio2_2022','10280','6','13536','all','AM',[5,6,12,10,4],rendimento_medio2)
sidrapy_populacao('rendimento_medio3_2022','10280','6','13536','all','AM',[5,6,12,10,4],rendimento_medio3)

#Pessoas de 15 anos ou mais de idade, total e as alfabetizadas, por sexo, cor ou raça e grupos de idade
sidrapy_populacao('alfabetizados_2022','9542','6','950','all','AM',[5,6,12,10,4],alfabetizadas)





