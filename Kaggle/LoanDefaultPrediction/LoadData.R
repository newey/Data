library(dplyr)
library(randomForest)
library(ggplot2)
library(lars)

colVars = function (col) {
  meansSquared = colMeans(col, na.rm = TRUE)**2
  squareMeans = colMeans(col**2, na.rm = TRUE)
  return (squareMeans - meansSquared)
  
}

traintbl = tbl(src_sqlite("train.db"), "train")
#traintbl = select(traintbl, id, f63,f140,f141,f146,f219,f220,f383,f441,f492,f533,f544,f554,f611,f746,f751,f756,f760,f775,loss)
#traintbl = select(traintbl, id, f2,f4,f5, f776,f777, f778,loss)
#traintbl = mutate(traintbl, bigdefault = loss>10)

traintbl = select(traintbl, -(f723), -(f33), -(f35), -(f34), -(f37), -(f38), -(f678), -(f700), -(f701), -(f702), -(f724), -(f736), -(f764))

traintbl = select(traintbl, -(f439), -(f457), -(f467), -(f478), -(f488), -(f498), -(f508), -(f12),  -(f763), -(f408), -(f770), -(f58),  -(f345), -(f354), -(f362), -(f371), -(f379), -(f417),
-(f427), -(f722), -(f729), -(f741), -(f86),  -(f87),  -(f88),  -(f96),  -(f97),  -(f98),  -(f106), -(f107), -(f108), -(f116), -(f117), -(f118), -(f126), -(f127),
-(f128), -(f155), -(f156), -(f157), -(f165), -(f166), -(f167), -(f175), -(f176), -(f177), -(f185), -(f186), -(f187), -(f195), -(f196), -(f197), -(f225), -(f226),
-(f227), -(f235), -(f236), -(f237), -(f245), -(f246), -(f247), -(f255), -(f256), -(f257), -(f265), -(f266), -(f267), -(f294), -(f295), -(f296), -(f302), -(f303),
 -(f304), -(f310), -(f311), -(f312), -(f318), -(f319), -(f320), -(f326), -(f327), -(f328), -(f553), -(f563), -(f573), -(f582), -(f599), -(f765))

traintbl = select(traintbl, -(f608),-(f532),-(f543),-(f74), -(f644),-(f452),-(f453),-(f493),-(f494),-(f503),-(f504),-(f483),-(f484),-(f473),-(f474),-(f462),-(f463),-(f538),
-(f539),-(f548),-(f549),-(f558),-(f559),-(f568),-(f569),-(f577),-(f578),-(f527),-(f528),-(f625),-(f768),-(f453),-(f463),-(f474),-(f484),-(f494),
-(f504),-(f528),-(f543),-(f539),-(f549),-(f559),-(f569),-(f578))

# >0.99 correlation
traintbl = select(traintbl, -(f10), -(f447),-(f606),-(f521),-(f674),-(f50), -(f40), -(f56), -(f22), -(f46), -(f24), -(f60), -(f377),-(f343),-(f352),-(f360),-(f369),-(f64),
-(f42), -(f48), -(f52), -(f62), -(f389),-(f633),-(f666),-(f681),-(f685),-(f712),-(f713),-(f728),-(f643),-(f645),-(f59), -(f61), -(f690),-(f706),
-(f711),-(f714),-(f651),-(f434),-(f435),-(f79), -(f437),-(f445),-(f446),-(f607),-(f115),-(f454),-(f460),-(f485),-(f491),-(f90), -(f91), -(f125),
-(f475),-(f481),-(f495),-(f501),-(f100),-(f101),-(f505),-(f511),-(f111),-(f121),-(f131),-(f464),-(f141),-(f146),-(f164),-(f174),-(f184),-(f194),
-(f169),-(f170),-(f190),-(f200),-(f215),-(f519),-(f254),-(f540),-(f545),-(f570),-(f575),-(f230),-(f264),-(f550),-(f555),-(f579),-(f584),-(f240),
-(f560),-(f565),-(f249),-(f250),-(f260),-(f270),-(f529),-(f280),-(f400),-(f675),-(f424),-(f331),-(f414),-(f415),-(f356),-(f358),-(f373),-(f689),
-(f692),-(f622),-(f623),-(f624),-(f626),-(f627),-(f628),-(f630),-(f766),-(f676),-(f767),-(f409),-(f410),-(f411),-(f440),-(f735),-(f610),-(f717),
-(f611),-(f486),-(f496),-(f642),-(f592),-(f520),-(f571),-(f580),-(f561),-(f587),-(f655),-(f662),-(f663),-(f686),-(f688),-(f691),-(f707),-(f708),
-(f748),-(f749),-(f757),-(f758),-(f761),-(f762),-(f687),-(f750),-(f774),-(f704),-(f705),-(f709),-(f710),-(f718),-(f719),-(f759),-(f720),-(f747),
-(f752),-(f753),-(f721),-(f730),-(f738),-(f754),-(f755),-(f771),-(f772),-(f773))

traintbl = select(traintbl,id,f13,f68,f72,f75,f76,f82,f112,f113,f122,f148,f149,f150,f154,f158,f159,f160,f180,f188,f198,
f207,f212,f219,f220,f393,f418,f422,f469,f482,f502,f531,f564,f567,f574,f597,f659,f669,f670,loss)

trnsubset = filter(traintbl, (id**3+7)*7919%%1051 < 500 )
testsubset = filter(traintbl, (id**3+7)*7919%%1051 >= 500)
trnsmall = filter(traintbl, (id**3+7)*7919%%1051 < 50 )
smalldf = data.frame(trnsmall)
#predsubset = c(f63,,f140,,f141,,f146,,f219,,f220,,f383,,f441,,f492,,f533,,f544,,f554,,f611,,f746,,f751,,f756,,f760,,f775,)


subdf = data.frame(trnsubset)
preds = names(subdf)[2:38]
subdf= subdf[complete.cases(subdf),]

subtest = data.frame(testsubset)
subtest = subtest[complete.cases(subtest),]


plot(ggplot(subdf, aes(x=loss, y=f9, alpha=1/2, color=(f4 > 6000 | f8 > 7300))) + geom_point())

rf = randomForest(x=subdf[,preds], y=factor(subdf$bigdefault), ntree = 100, xtest=subtest[,preds], ytest=factor(subtest$bigdefault), na.action=na.omit)
t = tree(factor(bigdefault) ~ factor(f2)+factor(f4)+factor(f5)+factor(f776)+factor(f777)+factor(f778)+-loss-id, subdf)
l = lars(as.matrix(subdf[,preds]), subdf$loss, trace=TRUE)



cormatrix = cor(smalldf, use="complete.obs")
x = c()
y = c()
nam = row.names(cormatrix)
for (i in which(abs(cormatrix) > 0.99)) {
  c1 = (i-1) %/% 476
  c2 = (i-1)%%476
  if (c1 < c2) {
    x = c(x, nam[c1+1])
    y = c(y, nam[c2+1])
    #print(paste(toString(c1), toString(c2)))
  }
}

View(data.frame(x,y))



