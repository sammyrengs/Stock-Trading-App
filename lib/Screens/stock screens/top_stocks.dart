class Stock{
  final String symbol;
  final String company;

  Stock({this.symbol='', this.company=''});

   static Map<String,String> stockList = {
    'GOOG' :'Alphabet Inc.',
    'AMZN' : 'Amazon.com, Inc.',
    'AAPL' : 'Apple Inc.',
    'MSFT' : 'Microsoft Corporation',
    'TSLA' :  'Tesla, Inc.',
    'FB' : 'Meta Platforms, Inc.',
    'NVDA' :  'NVIDIA Corporation',
    'JPM' :  'JP Morgan Chase and Co',
    'HD' : 'Home Depot, Inc.',
    'JNJ' : 'Johnson and Johnson',
    'UNH' : 'United Health Group Incorporated',
    'PG' : 'Procter and Gamble Company',
    'BAC' : 'Bank of America Corporation',
    'ADBE' : 'Abode Inc.',
    'DIS' : 'The Walt Disney Company',
  };


  static List<Stock> getAll(){
    List<Stock> stocks = [];
    stockList.forEach((k,v){
      String symb = k;
      String comp = v;
      stocks.add(Stock(symbol: symb, company: comp));
    });
    return stocks;
  }

  static String getComp(String symb){
    if(stockList[symb]!=null){
      return stockList[symb]!;
    } else{
      return 'Not Found!';
    }
  }

}
