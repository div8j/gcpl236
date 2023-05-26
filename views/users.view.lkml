# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: demo_db.users ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  parameter: parameter_check {
    type: string
    allowed_value: {
      label: "TL Office"
      value: "office"
    }
    allowed_value: {
      label: "Channel"
      value: "channel"
    }
    allowed_value: {
      label: "First Touch Attribution"
      value: "first_touch"
    }
    allowed_value: {
      label: "Company Form"
      value: "comp_form"
    }
    allowed_value: {
      label: "Company Size"
      value: "comp_size"
    }
    allowed_value: {
      label: "Created Via"
      value: "created_via"
    }
    allowed_value: {
      label: "Created on Mobile Device"
      value: "created_mobile"
    }
    allowed_value: {
      label: "Signed up Via Google"
      value: "sso_google"
    }
    allowed_value: {
      label: "Signup Survey Answers"
      value: "signup_survey"
    }
    allowed_value: {
      label: "[T] Checklist Version"
      value: "checklist_version"
    }
    allowed_value: {
      label: "[T] Customised Trial"
      value: "customised_trial"
    }
  }

  dimension: is_female {
    type: yesno
    sql: ${gender} = 'f' ;;
  }

  dimension: parameter_factor {
    group_label: "Trial Information"
    label_from_parameter: parameter_check
    type: string
    sql:
    CASE
    WHEN {% parameter parameter_check %} = 'office' THEN '1'
    WHEN {% parameter parameter_check %} = 'channel' THEN '2'
    WHEN {% parameter parameter_check %} = 'first_touch' THEN '3'
    WHEN {% parameter parameter_check %} = 'comp_form' THEN '4'
    WHEN {% parameter parameter_check %} = 'comp_size' THEN '5'
    WHEN {% parameter parameter_check %} = 'created_via' THEN '6'
    WHEN {% parameter parameter_check %} = 'created_mobile' THEN '7'
    WHEN {% parameter parameter_check %} = 'sso_google' THEN '8'
    WHEN {% parameter parameter_check %} = 'signup_survey' THEN '9'
    WHEN {% parameter parameter_check %} = 'checklist_version' THEN '10'
    WHEN {% parameter parameter_check %} = 'customised_trial' THEN ${is_female}
    ELSE NULL
    END ;;
  }


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: user_date {
    type: date_time
    sql: ${TABLE}.created_at;;
    #html: {{ rendered_value | date: "%m/%d/%Y" }} ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: buttonValue {
    type: string
    link: {
      label: "Test"
      url: "https://gcpl236.cloud.looker.com/dashboards/261?State={{ _filters['users.state'] | url_encode }}"
    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      saralooker.count,
      sindhu.count,
      user_data.count
    ]
  }
}
