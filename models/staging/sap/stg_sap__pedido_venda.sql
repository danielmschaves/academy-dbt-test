with src_cabecalho_pedido as (
   select * from {{ source('sap', 'salesorderheader') }}
),
cabecalho_pedido as (
   select
       -- chave primária
       salesorderid as ID_PEDIDO
       -- chaves estrangeiras
       , customerid as ID_CLIENTE
       , salespersonid as ID_VENDEDOR
       , territoryid as ID_TERRITORIO
       , billtoaddressid as ID_ENDERECO_COBRANCA
       , shiptoaddressid as ID_ENDERECO_ENTREGA
       , shipmethodid as ID_METODO_ENTREGA
       , creditcardid as ID_CARTAO_CREDITO
       , currencyrateid as ID_TAXA_CAMBIO
       -- texto
       , accountnumber as NUMERO_CONTA
       , creditcardapprovalcode as CODIGO_APROVACAO_CARTAO
       -- valores
       , freight as FRETE
       , purchaseordernumber as NUMERO_ORDEM_COMPRA
       , revisionnumber as NUMERO_REVISAO
       , status as STATUS
       , subtotal as SUBTOTAL
       , taxamt as VALOR_IMPOSTO
       , totaldue as VALOR_TOTAL
       -- booleano
       , onlineorderflag as FLAG_PEDIDO_ONLINE
       -- datas
       , cast(duedate as timestamp) as DATA_VENCIMENTO
       , cast(orderdate as timestamp) as DATA_PEDIDO
       , cast(shipdate as timestamp) as DATA_ENVIO
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
       -- chave única
       , rowguid as ID_LINHA_UNICO
   from 
       src_cabecalho_pedido
)
select * from cabecalho_pedido