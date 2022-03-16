table_spec = {
    "hadoop_datamart": {
        "dm_subscription_delta_daily_history": {
            "pk": "date",
            "period": "1",
            "query": """select 
						current_date() as date,
						count(*) as delta_count,
						distribution_channel_value as distribution_channel,
						tariff_plan_name  as tariff_plan_name
						from refined.vf_dim_subscription where actual_start_date >= current_date()
						group by 
						distribution_channel_value,
						tariff_plan_name;
            """
        },
        "dm_subscription_delta_change_plan_daily_history": {
            "pk": "date",
            "period": "1",
            "query": """select 
						current_date() as date,
						count(*) as delta_count,
						distribution_channel_value as distribution_channel,
						tariff_plan_name  as tariff_plan_name
						from refined.vf_dim_subscription where date_change_tariff_plan >= current_date()
						group by 
						distribution_channel_value,
						tariff_plan_name;
            """
        },
        "dm_subscription_cumulative_daily_history": {
            "pk": "date",
            "period": "1",
            "query": """select 
						current_date() as date,
						count(*) as cumulative_count,
						distribution_channel_value as distribution_channel,
						tariff_plan_name  as tariff_plan_name
						from refined.vf_dim_subscription
						group by
						distribution_channel_value,
						tariff_plan_name;
            """
        },
        "dm_port_out_daily_history": {
            "pk": "date",
            "period": "1",
            "query": """select 
						current_date() as date,
						count(*) as port_out_count 
						from refined.dim_phone_number ref
						left join interim.r_pb_phone_number i on (ref.pn_id=i.object_id)
						where logical_status_value='Ported Out'
					and i.sys_modified_when >= current_date();
            """
        },
        "dm_port_in_daily_history": {
            "pk": "date",
            "period": "7",
            "query": """select
						current_date() as date,
						count(*) as port_in_count
						from interim.r_pb_area_code ac
						join interim.r_pb_100k_range hr on hr.parent_id = ac.object_id
						join interim.r_pb_10k_range tr on tr.parent_id = hr.object_id
						join interim.r_pb_phone_number pn on pn.parent_id = tr.object_id
						where ac.object_id <> 9156806933813867300
						and pn.logical_status in ('Assigned','In Use')
						and pn.created_when >= current_date();
            """
        }
    },
    "greenplum_datamart": {
        #"dm_internet_consumption": {
        #    "pk": "event_dtm",
        #    "delta_col": "event_dtm",
        #    "period": "7",
        #    "query": "select * from hadoop_datamart.dm_internet_consumption"
        #}
        # "dim_billing_account": {
        #     "pk": "account_num"
        # },
        # "dim_businessproductinstances": {
        #     "pk": "account_num,customer_ref,customer_id,subs_id,bpi_id"
        # },
        # "dim_contactmethod": {
        #     "pk": "primary_customer_ref"
        # },
        # "dim_customer": {
        #     "pk": "customer_ref,customer_id"
        # },
        # "dim_distribution_chanel": {
        #     "pk": "distribution_chanel_id"
        # },
        # "dim_individual": {
        #     "pk": "individual_id"
        # },
        # "dim_productoffering_characteristic": {
        #     "pk": "productoffering_characteristic_id"
        # },
        # "dim_productofferings": {
        #     "pk": "productoffering_id"
        # },
        # "dim_subscription": {
        #     "period": None,
        #     "pk": "customer_ref,customer_id,subs_id,bpi_id"
        # },
        # "fct_bpi_history": {
        #     "pk": "customer_id,bpi_id"
        # },
        # "vf_dim_subscription": {
        #     "pk": "customer_ref,customer_id,billing_account_id,subs_id,bpi_id,sequence_number"
        # },
        # "dim_phone_number": {
        #     "pk": "phone_number"
        # },
        # "r_oe_sales_ord": {
        #     "query": "select * from RAW.r_oe_sales_ord",
        #     "pk": "object_id"
        # },
        # # "fct_prepaid_charges": {
        # #     "period": 48
        # # },
        # # "fct_prepaid_usages": {
        # #     "period": 48
        # # },
        # "vf_fct_payment_request": {
        #     "pk": "payment_request_id"
        # },
        # "vf_fct_payment_request_status": {
        #     "pk": "payment_request_status_id"
        # },
        # "vf_fct_payment_transaction": {
        #     "pk": "payment_transaction_id"
        # },
        # "vf_fct_payment_transaction_status": {
        #     "pk": "payment_transaction_status_id"
        # }
    }
}