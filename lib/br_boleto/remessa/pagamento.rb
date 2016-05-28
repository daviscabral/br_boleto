# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		class Pagamento < BrBoleto::ActiveModelBase
			# <b>REQUERIDO</b>: nosso numero
			attr_accessor :nosso_numero

			# <b>OPCIONAL</b>: Número do Documento de Cobrança - Número adotado e controlado pelo Cliente,
			# para identificar o título de cobrança.
			# Informação utilizada para referenciar a identificação do documento objeto de cobrança.
			# Poderá conter número de duplicata, no caso de cobrança de duplicatas; número da apólice,
			# no caso de cobrança de seguros, etc
			attr_accessor :numero_documento

			# <b>REQUERIDO</b>: data do vencimento do boleto
			attr_accessor :data_vencimento

			# <b>REQUERIDO</b>: data de emissao do boleto
			attr_accessor :data_emissao

			# <b>REQUERIDO</b>: valor_documento do boleto
			attr_accessor :valor_documento

			# <b>REQUERIDO</b>: documento do sacado (cliente)
			attr_accessor :documento_sacado

			# <b>REQUERIDO</b>: nome do sacado (cliente)
			attr_accessor :nome_sacado

			# <b>REQUERIDO</b>: endereco do sacado (cliente)
			attr_accessor :endereco_sacado

			# <b>REQUERIDO</b>: bairro do sacado (cliente)
			attr_accessor :bairro_sacado

			# <b>REQUERIDO</b>: CEP do sacado (cliente)
			attr_accessor :cep_sacado

			# <b>REQUERIDO</b>: cidade do sacado (cliente)
			attr_accessor :cidade_sacado

			# <b>REQUERIDO</b>: UF do sacado (cliente)
			attr_accessor :uf_sacado

			# <b>REQUERIDO</b>: Tipor de impressão
			#                   1 - Frente do Bloqueto
			#                   2 - Verso do Bloauqto
			#                   3 - Corpo de instruções da Ficha de Complansação
			# 
			attr_accessor :tipo_impressao # Default '1'

			# <b>OPCIONAL</b>: nome do avalista
			attr_accessor :nome_avalista

			# <b>OPCIONAL</b>: documento do avalista
			attr_accessor :documento_avalista

			# <b>OPCIONAL</b>: codigo da 1a instrucao
			attr_accessor :cod_primeira_instrucao

			# <b>OPCIONAL</b>: codigo da 2a instrucao
			attr_accessor :cod_segunda_instrucao

			# <b>OPCIONAL</b>: valor da mora ao dia
			attr_accessor :valor_mora

			# <b>OPCIONAL</b>: data limite para o desconto
			attr_accessor :data_desconto

			# <b>OPCIONAL</b>: valor a ser concedido de desconto
			attr_accessor :valor_desconto

			# <b>OPCIONAL</b>: codigo do desconto (para CNAB240)
			attr_accessor :cod_desconto

			# <b>OPCIONAL</b>: valor do IOF
			attr_accessor :valor_iof
			
			# <b>OPCIONAL</b>: valor do abatimento
			attr_accessor :valor_abatimento

			# <b>OPCIONAL</b>: Informações para o desconto 2
			attr_accessor :desconto_2_codigo, :desconto_2_data, :desconto_2_valor

			# <b>OPCIONAL</b>: Informações para o desconto 3
			attr_accessor :desconto_3_codigo, :desconto_3_data, :desconto_3_valor

			# <b>OPCIONAL</b>: Informações para multa
			#  Código da multa pode ser:
			#      - '1' Valor por Dia
			#      - '2' Taxa Mensal
			#      - '3' Isento
			#      - E Ainda alguns bancos como o SICOOB não conseguem seguir o padrão e usam o cód '0' para Isento
			attr_accessor :codigo_multa, :data_multa, :valor_multa

			# <b>OPCIONAL</b>: Informações para Juros
			#  Código do juros pode ser:
			#      - '1' Valor por Dia
			#      - '2' Taxa Mensal
			#      - '3' Isento
			#      - E Ainda alguns bancos como o SICOOB não conseguem seguir o padrão e usam o cód '0' para Isento
			attr_accessor :codigo_juros, :data_juros, :valor_juros

			def cep_sacado
				"#{@cep_sacado}".gsub(/[^0-9]/, "")
			end

			def nosso_numero
				"#{@nosso_numero}".gsub(/[^0-9]/, "")
			end

			validates :nosso_numero, :data_vencimento, :valor_documento, :documento_sacado, :nome_sacado, 
			          :endereco_sacado, :cep_sacado, :cidade_sacado, :uf_sacado, :bairro_sacado, :tipo_impressao,
			          presence: true

			validates :cep_sacado,   length: {is: 8, message: 'deve ter 8 dígitos.'}
			validates :cod_desconto, length: {is: 1, message: 'deve ter 1 dígito.'}

			def default_values
				{
					data_emissao:      Date.today,
					valor_mora:        0.0,
					valor_desconto:    0.0,
					valor_iof:         0.0,
					valor_abatimento:  0.0,
					nome_avalista:     '',
					cod_desconto:      '0',
					desconto_2_codigo: '0',
					desconto_2_valor:  0.0,
					desconto_3_codigo: '0',
					desconto_3_valor:  0.0,
					codigo_multa:      '3', # Isento
					codigo_juros:      '3', # Isento
					valor_multa:       0.0,
					valor_juros:       0.0,
					tipo_impressao:    '1'
				}
			end

			# Formata a data de descontos de acordo com o formato passado
			#
			# @return [String]
			#
			def data_desconto_formatado(formato = '%d%m%Y')
				formata_data(data_desconto, formato)
			end
			def desconto_2_data_formatado(formato = '%d%m%Y')
				formata_data(desconto_2_data, formato)
			end
			def desconto_3_data_formatado(formato = '%d%m%Y')
				formata_data(desconto_3_data, formato)
			end

			# Formatação para campos da multa
			def data_multa_formatado(formato = '%d%m%Y')
				formata_data(data_multa, formato)
			end
			def valor_multa_formatado(tamanho=13)
				BrBoleto::Helper::Number.new(valor_multa).formata_valor_monetario(tamanho) 
			end

			# Formatação para campos da juros
			def data_juros_formatado(formato = '%d%m%Y')
				formata_data(data_juros, formato)
			end
			def valor_juros_formatado(tamanho=13)
				BrBoleto::Helper::Number.new(valor_juros).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor
			# referentes as casas decimais
			# exe. R$199,90 => 0000000019990
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_documento_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_documento).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor da mora
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_mora_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_mora).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor dos descontos
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_desconto_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_desconto).formata_valor_monetario(tamanho) 
			end
			def desconto_2_valor_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(desconto_2_valor).formata_valor_monetario(tamanho) 
			end
			def desconto_3_valor_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(desconto_3_valor).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor do IOF
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_iof_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_iof).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor do IOF
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_abatimento_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_abatimento).formata_valor_monetario(tamanho) 
			end

			# Retorna a identificacao do pagador
			# Se for pessoa fisica (CPF com 11 digitos) é 1
			# Se for juridica (CNPJ com 14 digitos) é 2
			#
			def tipo_documento_sacado(tamanho = 2)
				BrBoleto::Helper::CpfCnpj.new(documento_sacado).tipo_documento(tamanho)
			end

			# Retorna a identificacao do avalista
			# Se for pessoa fisica (CPF com 11 digitos) é 1
			# Se for juridica (CNPJ com 14 digitos) é 2
			#
			def tipo_documento_avalista(tamanho = 2)
				BrBoleto::Helper::CpfCnpj.new(documento_avalista).tipo_documento(tamanho)
			end
		private

			def formata_data(value, formato="%d%m%Y")
				value.strftime(formato)
			rescue
				return (formato == '%d%m%y' ?  '000000' : '00000000')
			end
		end
	end
end