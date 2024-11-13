-- int_vendas_pedidos.sql
with stg_pedido_vendas as (
   select * from {{ ref('stg_sap__pedido_venda') }}
),
stg_detalhes_pedido_venda as (
   select * from {{ ref('stg_sap__detalhes_pedido_venda') }}
),
stg_cartao_credito as (
   select * from {{ ref('stg_sap__cartao_credito') }}
),
vendas_pedidos as (
   select
       dpv.ID_DETALHE_PEDIDO
       , dpv.ID_PEDIDO
       , dpv.ID_PRODUTO
       , pv.ID_CLIENTE
       , dpv.ID_OFERTA_ESPECIAL
       , pv.ID_VENDEDOR
       , pv.ID_TERRITORIO
       , pv.ID_ENDERECO_COBRANCA
       , pv.ID_CARTAO_CREDITO
       , case
           when cc.TIPO_CARTAO is null then 'Sem Cartão'
           else cc.TIPO_CARTAO
         end as TIPO_CARTAO
       , dpv.PRECO_UNITARIO
       , dpv.DESCONTO_UNITARIO
       , dpv.QUANTIDADE
       , pv.FRETE
       , pv.NUMERO_ORDEM_COMPRA
       , pv.NUMERO_REVISAO
       , case
           when pv.STATUS = 1 then 'Em Processo'
           when pv.STATUS = 2 then 'Aprovado'
           when pv.STATUS = 3 then 'Pendente'
           when pv.STATUS = 4 then 'Rejeitado'
           when pv.STATUS = 5 then 'Enviado'
           when pv.STATUS = 6 then 'Cancelado'
         end as STATUS
       , pv.SUBTOTAL
       , pv.VALOR_IMPOSTO
       , pv.VALOR_TOTAL
       , dpv.PRECO_UNITARIO * dpv.QUANTIDADE as VALOR_BRUTO
       , dpv.PRECO_UNITARIO * dpv.QUANTIDADE * (1 - dpv.DESCONTO_UNITARIO) as VALOR_LIQUIDO
       , pv.FLAG_PEDIDO_ONLINE
       , pv.DATA_PEDIDO
   from stg_detalhes_pedido_venda as dpv
   left join stg_pedido_vendas pv 
       on dpv.ID_PEDIDO = pv.ID_PEDIDO
   left join stg_cartao_credito as cc 
       on cc.ID_CARTAO = pv.ID_CARTAO_CREDITO
)
select * from vendas_pedidos