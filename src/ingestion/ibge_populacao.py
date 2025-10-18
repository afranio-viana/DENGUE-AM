from modules.sidrapy_requests import sidrapy_populacao



genero = {'2':'4,5'}
idade1 = {'287':'93070,93084,93085,93086,93087,93088,93089,93090'}
idade2 = {'287':'93091,93092,93093,93094,93095,93096,93097,93098'}
idade3 = {'287':'49108,49109,60040,60041,6653'}
forma_abastecimento = {'301':'31471,72054,72055,72088,31472,72089,72090,72091'}
existencia_canalizacao = {'1817':'72126,72127,72128'}


sidrapy_populacao("populacao_2022","4709","6","93","all","AM",[5,6,4,10],None)
sidrapy_populacao("densidade_demografica_2022","4714","6","614","all","AM",[5,6,4,10],None)
sidrapy_populacao('genero_2022','9514','6','93','all','AM',[5,6,12,10,4],genero)
sidrapy_populacao('faixa_etaria1_2022','9514','6','93','all','AM',[5,6,12,10,4],idade1)
sidrapy_populacao('faixa_etaria2_2022','9514','6','93','all','AM',[5,6,12,10,4],idade2)
sidrapy_populacao('faixa_etaria3_2022','9514','6','93','all','AM',[5,6,12,10,4],idade3)
sidrapy_populacao('forma_abastecimento_2022','6804','6','381','all','AM',[5,6,12,10,4],forma_abastecimento)
sidrapy_populacao('existencia_canalizacao_2022','6804','6','381','all','AM',[5,6,12,10,4],existencia_canalizacao)


