class Rain {
  double? d3h;

  Rain({this.d3h});

  factory Rain.fromJson(Map<String, dynamic> json) => Rain(
        d3h: (json['3h'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        '3h': d3h,
      };
}
