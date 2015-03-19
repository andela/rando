def sample_transaction_api_response
  '{
        "posted_lines": [
          {
            "id": "wrlFLCuz7cDldBUoUrlvDQ",
            "journal_entry": "nGM69VE1GUc9QqeZ9jfmgV",
            "account": "vsfM9fHDnEB6J8jHliNTKq",
            "description": "christopher@andela.co",
            "reference": "http://www.andela.co/",
            "value": {
              "type": "credit",
              "amount": "100"
            },
            "order": "0001.00",
            "version": 1,
            "effective_at": "2014-08-01T01:02:50.000Z",
            "posted_at": "2015-03-07T23:34:12.244Z",
            "balance": {
              "debit_value": {
                "type": "debit",
                "amount": "100"
              },
              "credit_value": {
                "type": "zero",
                "amount": "0"
              },
              "value": {
                "type": "credit",
                "amount": "100"
              }
            }
          }
        ]
      }
    '
end

def balance
  '
    {
  "balance": {
    "debit_value": {
      "type": "debit",
      "amount": "295527"
    },
    "credit_value": {
      "type": "credit",
      "amount": "261367"
    },
    "value": {
      "type": "debit",
      "amount": "34160"
    }
  }
}
    '
end
def expected_transactions
  '
    [
      {
        "id": "wrlFLCuz7cDldBUoUrlvDQ",
        "journal_entry": "nGM69VE1GUc9QqeZ9jfmgV",
        "account": "vsfM9fHDnEB6J8jHliNTKq",
        "description": "christopher@andela.co",
        "reference": "http://www.andela.co/",
        "value": {
          "type": "credit",
          "amount": "100"
        },
        "order": "0001.00",
        "version": 1,
        "effective_at": "2014-08-01T01:02:50.000Z",
        "posted_at": "2015-03-07T23:34:12.244Z",
        "balance": {
          "debit_value": {
            "type": "debit",
            "amount": "100"
          },
          "credit_value": {
            "type": "zero",
            "amount": "0"
          },
          "value": {
            "type": "credit",
            "amount": "100"
          }
        }
      },
{
            "id": "wrlFLCuz7cDldBUoUrlvDQ",
            "journal_entry": "nGM69VE1GUc9QqeZ9jfmgV",
            "account": "vsfM9fHDnEB6J8jHliNTKq",
            "description": "franklin.ugwu@andela.co",
            "reference": "http://www.andela.co/",
            "value": {
              "type": "debit",
              "amount": "100"
            },
            "order": "0001.00",
            "version": 1,
            "effective_at": "2014-08-01T01:02:50.000Z",
            "posted_at": "2015-03-07T23:34:12.244Z",
            "balance": {
              "debit_value": {
                "type": "debit",
                "amount": "100"
              },
              "credit_value": {
                "type": "zero",
                "amount": "0"
              },
              "value": {
                "type": "debit",
                "amount": "100"
              }
            }
          }
    ]
    '
end

def sample_transaction_api_response_debit
  '{
        "posted_lines": [
          {
            "id": "wrlFLCuz7cDldBUoUrlvDQ",
            "journal_entry": "nGM69VE1GUc9QqeZ9jfmgV",
            "account": "vsfM9fHDnEB6J8jHliNTKq",
            "description": "franklin.ugwu@andela.co",
            "reference": "http://www.andela.co/",
            "value": {
              "type": "debit",
              "amount": "100"
            },
            "order": "0001.00",
            "version": 1,
            "effective_at": "2014-08-01T01:02:50.000Z",
            "posted_at": "2015-03-07T23:34:12.244Z",
            "balance": {
              "debit_value": {
                "type": "debit",
                "amount": "100"
              },
              "credit_value": {
                "type": "zero",
                "amount": "0"
              },
              "value": {
                "type": "debit",
                "amount": "100"
              }
            }
          }
        ]
      }
    '
end