-- Erro se a soma de vendas brutas for menor que 1% $12.646.112,16 */

with vendas_2011 as (
   select 
       sum(f.VALOR_BRUTO) as total
   from {{ ref('fato_vendas') }} f
   left join {{ ref('dim_data') }} d 
       on f.FK_DATA = d.SK_DATA
   where d.ANO = 2011
)

select * 
from vendas_2011 
where total not between 0.99 * 12646112.16 and 1.01 * 12646112.16