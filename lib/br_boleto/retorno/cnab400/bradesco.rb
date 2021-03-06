# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab400
			class Bradesco < BrBoleto::Retorno::Cnab400::Base
			private
				def detalhe_fields #:doc:
					{ #    ATRIBUTO               POSIÇÃO DA LINHA

						sacado_documento:              4..17,
						carteira:                      23..24,
						agencia_sem_dv:                25..29,
						# agencia_com_dv:              25..29,
						numero_conta_sem_dv:           30..35,
						numero_conta_dv:               36,
						nosso_numero_sem_dv:           71..81,
						nosso_numero_dv:               82,
						codigo_ocorrencia_retorno:     109..110,
						data_ocorrencia:               111..116,
						data_ocorrencia_sacado:        111..116,
						numero_documento:              117..126,
						data_vencimento:               147..152,
						valor_titulo:                  153..165,
						agencia_recebedora_com_dv:     169..173,
						banco_recebedor:               166..168,
						especie_titulo:                174..175,
						valor_tarifa:                  176..188,
						valor_outras_despesas:         189..201,
						valor_juros_multa:             267..279,
						valor_iof:                     215..227,
						valor_abatimento:              228..240,
						valor_desconto:                241..253,
						valor_pago:                    254..266,
						valor_ocorrencia_sacado:       254..266,
						valor_liquido:                 254..266,
						valor_outros_creditos:         280..292,
						data_credito:                  296..301,
						
						motivo_ocorrencia_original_1:  319..320,
						motivo_ocorrencia_original_2:  321..322,
						motivo_ocorrencia_original_3:  323..324,
						motivo_ocorrencia_original_4:  325..326,
						motivo_ocorrencia_original_5:  327..328,
					}
				end
			end
		end
	end
end