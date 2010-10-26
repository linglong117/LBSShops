//
//  ShopInfo.m
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//
#import <sqlite3.h>
#import "ShopInfo.h"
#import "DataManager.h"
#import "Predfin.h"

static NSMutableArray * alls = nil;

@implementation ShopInfo

@synthesize imagename, name, address, altitude, longitude;
@synthesize description, telephone, discountInfo, cardType;
@synthesize distance;

+ (NSArray *) nearShops:(CLLocation *)curLoc {
	NSMutableArray * nears = [NSMutableArray arrayWithCapacity: 4];
	
	NSArray * allshops = [ShopInfo allShops];
	
	for (int i=0; i<[allshops count]; ++i) {
		ShopInfo * shop = (ShopInfo *)[allshops objectAtIndex:i];
		double la = [shop.altitude doubleValue];
		double lo = [shop.longitude doubleValue];
		CLLocation * loc = [[CLLocation alloc] initWithLatitude:la longitude:lo];
		[loc autorelease];
		
		double dis = [curLoc getDistanceFrom: loc];
		if ( dis <= 1200.00) {
			shop.distance = dis;
			[nears addObject: shop];
		}
	}
	
	NSArray * arr = [NSArray arrayWithArray: nears];
	return arr;
}

+ (NSArray *) allShops {
	if (alls != nil) {
		return alls;
	}
	
	alls = [[NSMutableArray alloc] init];
	//alls = [NSMutableArray arrayWithCapacity: 10];
	//[alls retain];

	NSMutableArray *array  = [[DataManager sharedManager] getShopsData];
	NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithArray:array] mutableCopy];
	
	for (int i=0; i<[dataArray count]; i++) {
		NSMutableDictionary *dic = [dataArray objectAtIndex:i];
		
		ShopInfo * shop = [[[ShopInfo alloc] init] autorelease];	
		shop.imagename = [dic objectForKey:@"imagename"];
		shop.name = [dic objectForKey:@"name"];
		shop.address = [dic objectForKey:@"address"];
		shop.altitude	= [dic objectForKey:@"altitude"];
		shop.longitude  = [dic objectForKey:@"longitude"];
		shop.description = [dic objectForKey:@"description"];
		shop.telephone = [dic objectForKey:@"telephone"];
		shop.discountInfo  = [dic objectForKey:@"discountInfo"];
		shop.cardType = [dic objectForKey:@"cardType"];	
		[alls addObject: shop];
	}
	
	[dataArray release];
	//NSLog(@"%@  ",[alls description]);
	
	
#if 0
	ShopInfo * shop = [[[ShopInfo alloc] init] autorelease];	
	shop.imagename = @"shop0.png";
	shop.name = @"张博士茗茶馆	";
	shop.address = @"芳甸路300号B区405单元";
	shop.altitude	= @"31.226735";
	shop.longitude  = @"121.557585";
	shop.description = @"装修凸显中式特色,店面虽不大,却有小桥曲水,小鱼和龟儿在水中散游,非常雅致,店中央摆有古琴,偶有乐师弹奏.这家茶馆主打普洱茶,虽也有铁观音等别的茶种,服务也很到位,入座便有几碟瓜子小食赠送,点了茶之后,服务员小姐会为客人泡茶,不用自己动手.还支持无线上网,也有面,饭等点心供应.点一壶茶,上上网,消磨一个下午的时间,一点儿也不难.";
	shop.telephone = @"021-61017517";
	shop.discountInfo  = @"刷卡消费享受9.5折优惠（烟、酒除外，不与其他优惠同时享受）";
	shop.cardType = @"金卡";	
	[alls addObject: shop];
	
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop1.png";
	shop.name = @"圆苑酒家";
	shop.address = @"静安区南京西路1038号梅龙镇广场4楼";
	shop.altitude	= @"31.228628";
	shop.longitude  = @"121.456729";
	shop.description = @"圆苑酒家以经营地道上海菜和经典粤菜为特色，承蒙各界人士爱戴被冠以“沪上红烧第一家”之称。特别是由本店烧制而成的 “ 红烧肉 ”， 油而不腻，酥而不烂，广受宾客青睐。圆苑酒家目前在上海有6家分店，北京1家分店。餐厅装潢典雅，充满低调奢华的老上海风情，温馨专业的服务，精心制作的美食，让在享受“食”之精彩的同时体会中华美食之神韵。";
	shop.telephone = @"021-62726972";
	shop.discountInfo  = @"刷卡消费享受8.8折优惠";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];
		
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop2.png";
	shop.name = @"忆品法式铁板烧";
	shop.address = @"闵行区沪青平公路395号";
	shop.altitude	= @"31.229421";
	shop.longitude  = @"121.456314";
	shop.description = @"环境很优雅，有点象咖啡厅呵呵！口味真的很不错，尤其是菲力牛排，很嫩的！";
	shop.telephone = @"021-54492566";
	shop.discountInfo  = @"刷卡消费套餐享受9折优惠";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop3.png";
	shop.name = @"本杰比印度料理";
	shop.address = @"浦东新区芳甸路199弄43号";
	shop.altitude	= @"31.176888";
	shop.longitude  = @"121.34557";
	shop.description = @"到处是漂亮而又经典的印度式建筑和在街头随处能见到的印度后裔——德班，南非的一个城市，又称‘印度城’，在那里吃过的咖喱，当然是正宗而又美味的。对我来讲，咖喱是印度的文化之一。听说本杰比的老板和大厨都来自于印度，怀着对咖喱的特有情结，去那里大快朵颐了一次——很可口，喜欢闻那股masala的味道，可是口味有点迎合了我们当地人的口味.有点遗憾。菜可以单点，也有自助的选择，薄饼和咖喱是万万不能错过的";
	shop.telephone = @"021-50332642";
	shop.discountInfo  = @"刷交通银行卡消费享受9折优惠(酒水,套餐除外)，不与其他优惠同时享受";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop4.png";
	shop.name = @"品粤阁";
	shop.address = @"浦东松涛路251号";
	shop.altitude	= @"31.227347";
	shop.longitude  = @"121.558454";
	shop.description = @"粤菜馆，适宜商务宴请、朋友聚会";
	shop.telephone = @"021-50808183";
	shop.discountInfo  = @"刷卡消费享受8.8折优惠";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];						
		
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop25.png";
	shop.name = @"才谷屋日本料理";
	shop.address = @"长宁区仙霞路299号一层11号";
	shop.altitude	= @"31.264832";
	shop.longitude  = @"121.483297";
	shop.description = @"很正宗的日式餐厅，日本氛围很浓";
	shop.telephone = @"021-62197398";
	shop.discountInfo  = @"刷卡消费享受夜市9折优惠，只要消费就送啤酒一杯";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];					
	
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop24.png";
	shop.name = @"张生记";
	shop.address = @"徐汇区肇嘉浜路446号3层";
	shop.altitude	= @"31.206085";
	shop.longitude  = @"121.401908";
	shop.description = @"沪上“老牌”的杭帮菜馆。菜肴首推笋干老鸭煲——用的是“整只的老鸭”加上“火腿肉、笋干及荷叶”炖成，荷叶“去掉了老鸭的膻味”，火腿“提吊了鸭肉的鲜味”，实在“太鲜美”了，几乎“每桌必点”。价格也是“厉害的”，不过还算“物有所值”。几家分店数正大广场店环境“最好”，靠窗的位子能欣赏浦江“夜景”。";
	shop.telephone = @"021-64455777";
	shop.discountInfo  = @"刷卡消费享受午市9折优惠";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	
		
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop23.png";
	shop.name = @"三人行骨头王火锅";
	shop.address = @"肇嘉浜路879号";
	shop.altitude	= @"31.201664";
	shop.longitude  = @"121.455248";
	shop.description = @"三人行是上海很有名的骨头火锅，份量大和店名一样，三人同行，一锅足矣。以骨头的美味赢得顾客的喜爱，骨头选用的材料都是后腿肉，骨头有嚼劲，骨髓也多。 环境优雅时尚，整齐的桌面、舒适的沙发坐、紫色的窗纱，加上墙上一大幅黄玫瑰，让餐厅有着活泼时尚的感觉。不妨三人或多人同行，来啃骨头吧。";
	shop.telephone = @"021-64682289";
	shop.discountInfo  = @"刷卡消费享受8.5折优惠";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];			
			
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop22.png";
	shop.name = @"美丽时光餐厅";
	shop.address = @"芳甸路199弄12号";
	shop.altitude	= @"31.197073";
	shop.longitude  = @"121.445467";
	shop.description = @"美丽时光酒吧地里位置好，位于浦东大拇指广场内，吧内结构合理，装修豪华，给人紧凑而又自如的感觉。酒吧设有一流的音响设备，豪华的设备、炫目的灯效、动感的慢摇，坐在任何一个角落都能感受强烈的音乐，淋漓畅快。以独特的消费方式，经营理念深受广大客户尤其是年轻人的喜爱及好评,是休闲娱乐、消除疲劳、放松的好去处。";
	shop.telephone = @"021-50339879";
	shop.discountInfo  = @"刷卡消费满200元以上送价值20元爆米花一份，满500元以上送价值60元水果一份，满1000元以上送价值80元水果盘以及价值20元爆米花一份";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];		
		
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop21.png";
	shop.name = @"骏莱海鲜鱼港";
	shop.address = @"杨浦区长阳路1681号";
	shop.altitude	= @"31.228362";
	shop.longitude  = @"121.538744";
	shop.description = @"厅堂装修得“金光闪闪”，包厢“雅致舒适”，宴请客人“挺有面子”。海鲜都“蛮新鲜”，味道自然“不差”。";
	shop.telephone = @"021-65192727";
	shop.discountInfo  = @"刷卡消费享受9.2折优惠（烟酒、特价菜、外供商品除外，不与其它特惠同享）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];
								
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop20.png";
	shop.name = @"雍福会";
	shop.address = @"上海市徐汇区永福路200号";
	shop.altitude	= @"31.270188";
	shop.longitude  = @"121.535268";
	shop.description = @"雍福会坐落于上海市中心的领馆区，也就是百年前的法租界内，主楼建筑于上世纪三十年代，经会所主人及设师计汪兴政三年多的悉心策划和建造，将原先的英国领事馆旧址改建成了一家近乎博物馆的花园餐厅，匠心独特，在上海堪称唯一。";
	shop.telephone = @"86-21-54662727";
	shop.discountInfo  = @"午餐 (11: 30am－14: 00pm): 免收15%服务费（周六、周日除外）婚宴：免费提供花园草坪为新人举行婚礼仪式 （50人以上） 1. 于消费前先告知服务人员及出示上述MasterCard信用卡，并使用该卡消费才可享受优惠 2. 以上优惠不可转让；只适用于上述产品 / 服务；不可兑换现金 3. 不可与其他优惠一起使用 4. 建议通过电话或电邮预先定位 5. 雍福会保留对以上优惠信息的最终解释权";
	shop.cardType = @"白金";
	[alls addObject: shop];			
	
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop19.png";
	shop.name = @"灶鼎阁（静安店）";
	shop.address = @"武定西路1189号";
	shop.altitude	= @"31.217981";
	shop.longitude  = @"121.516829";
	shop.description = @"初闻“灶鼎阁”，感觉就象是农家土菜。迎门而入，放眼远望，“屋中之阁”远比想象中来得大，黑白分明的主基调，颇具视觉冲击，使整个空间更显开阔通透，楼层挑高毫无压抑之感，阁内随处可见的精致水晶吊灯，把空间照射得夜如白昼，清雅而具时尚气息的氛围，令人心情豁然开朗，食欲大开。";
	shop.telephone = @"021-62491333";
	shop.discountInfo  = @"刷卡享受8.5折优惠（河海鲜、酒水、特价菜除外）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];		
			
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop18.png";
	shop.name = @"芙瑞丝（胶州店）";
	shop.address = @"静安区胶州路5号";
	shop.altitude	= @"31.226505";
	shop.longitude  = @"121.435494";
	shop.description = @"芙瑞诗是一家连锁面包房，起酥类比较受欢迎，还有用料充足的蛋糕，柔软而奶香味十足。";
	shop.telephone = @"021-62588293";
	shop.discountInfo  = @"刷卡消费普卡享受9折优惠，金卡、白金卡享受8折优惠（不与其他优惠同事享受，每天19点后均享受8折优惠）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];				
								
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop17.png";
	shop.name = @"黄腾酒家";
	shop.address = @"黄浦区黄河路73号底层";
	shop.altitude	= @"31.233014";
	shop.longitude  = @"121.472848";
	shop.description = @"菜式以本帮为主，虽然味道不是特别出色，但也不会差到哪里去，质量也一直很稳定。量蛮大的。价钱比黄河路均价要高点，但还比较实惠，午市和晚市都有打折。环境简洁干净，车厢座的位置很适合情侣。";
	shop.telephone = @"021-63277090";
	shop.discountInfo  = @"刷卡消费享受8.8折优惠（河海鲜、酒水、特价菜除外，不与其他优惠同时享用）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];
			
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop16.png";
	shop.name = @"颐风茶道";
	shop.address = @"沙岗路588号";
	shop.altitude	= @"31.234452";
	shop.longitude  = @"121.470737";
	shop.description = @"颐风弘扬的是中华民族的茶道，茶道是修身养性的一种方式，通过沏茶、赏茶、饮茶、美心修德、学习礼法，是一种有益的、蕴涵着高雅、恬静的东方哲学。茶道是更高的精神和道德要求";
	shop.telephone = @"021-65382800";
	shop.discountInfo  = @"刷卡享受9.5折优惠（烟、酒、续场费、小孩茶位费除外";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];		
		
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop15.png";
	shop.name = @"小梁园（明档店）";
	shop.address = @"山东中路208号";
	shop.altitude	= @"31.300066";
	shop.longitude  = @"121.536159";
	shop.description = @"“小梁园”各店都配有大型免费停车场，以弘扬中华饮食文化开创“小梁园”美食品牌为宗旨，集各派菜系风格之大成，融汇江浙、沪、川之经典为一体，适合家常菜肴之新潮，特聘沪上名家主理做法新颖独特，出品精良上乘，价格实惠公道，可承办喜庆宴席、生日聚会、商务宴请、会议餐席等中型宴席、亦为合家欢聚、情侣约会、朋友小酌之理想场所，美味可口的佳肴、宽敞明亮的环境、热情范围——带给您怡人、温馨和舒适。";
	shop.telephone = @"021-63612131";
	shop.discountInfo  = @"刷卡享受全单9.5折优惠";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];		

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop14.png";
	shop.name = @"现代生活美食餐厅";
	shop.address = @"石门二路19号";
	shop.altitude	= @"31.23471";
	shop.longitude  = @"121.484571";
	shop.description = @"小厨餐点为主，快捷方便，商务套餐";
	shop.telephone = @"021-62569629";
	shop.discountInfo  = @"刷交通银行太平洋卡可享受9折优惠（全单）；不与其他优惠同享。";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];		
	
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop13.png";
	shop.name = @"苏武牧羊（普陀店）";
	shop.address = @"普陀区大渡河路1558号";
	shop.altitude	= @"31.231757";
	shop.longitude  = @"121.46183";
	shop.description = @"老牌的火锅店，走的是大众路线。适合年轻人聚会、家庭聚会及朋友聚会，而且店内优惠活动很多，更值得一提的是里面的锅底，料多味美，越煮越入味，还有免费豆浆提供，是冬天里吃火锅人士的首选。";
	shop.telephone = @"021-62653777-8508";
	shop.discountInfo  = @"刷卡消费享受8.8折优惠（酒水、锅底、烧烤除外，不与其他优惠同时享用）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop12.png";
	shop.name = @"阿一海鲜酒家";
	shop.address = @"黄浦区淮海东路45号3楼";
	shop.altitude	= @"31.247359";
	shop.longitude  = @"121.397099";
	shop.description = @"燕鲍翅、适宜商务宴请";
	shop.telephone = @"021-63336188";
	shop.discountInfo  = @"刷卡消费享受9折优惠（特价菜特价点心除外，不与其他优惠同享）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop11.png";
	shop.name = @"上海1号（卢湾店）";
	shop.address = @"瑞金南路1号3F1号";
	shop.altitude	= @"31.302608";
	shop.longitude  = @"121.490421";
	shop.description = @"算是比较有“上海特色”的店。包房都是以上海的地名来命名，墙上也是老上海的照片。菜的话主要是“传统”的本帮菜，量“不算大”，但是做得“挺精致”的，味道也“不错”。午市茶点生意火爆。";
	shop.telephone = @"021-64189777";
	shop.discountInfo  = @"刷卡消费享受8.8折优惠，另送甜品一份（燕鲍翅、海鲜、酒水除外）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop10.png";
	shop.name = @"梧桐小镇（龙之梦店）";
	shop.address = @"长宁路1018号";
	shop.altitude	= @"31.209516";
	shop.longitude  = @"121.449544";
	shop.description = @"本店菜系是自主研发的新派菜系“海派中餐”，该菜系是以“老八大菜系”中一些脍炙人口深受人们喜爱的特色菜为基础，经过我们的不断改良和创新，是更符合现代人多元化口味、简介大方的审美观念的现代新菜系，能满足当代人对美食口味的要求。我们的服务是以亲切、温馨为理念，轻松愉快的用餐心情是我们对服务品质的追求!";
	shop.telephone = @"021-52395757";
	shop.discountInfo  = @"刷卡享受9折优惠（河海鲜、酒水、特价菜除外)";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop9.png";
	shop.name = @"老妈米线（四川北路店）";
	shop.address = @"四川北路2118号";
	shop.altitude	= @"31.218191";
	shop.longitude  = @"121.416358";
	shop.description = @"“料出云贵，味在四川”，植根于云、贵、川美食文化土壤的老妈米线，兼收了中华美食地域特色和现代美食元素，结合当今人们对饮食快捷、多样、健康的需求而进行了推陈出新。 南人饭米、北人饭面，老妈米线是以米食为主的餐厅，但又不拘于米食，外延扩大在面、饭、蒸点等精美小吃、小菜、甜品、冷热饮。加工方法以国人喜爱的汤水炖煮为主，以健康蒸、烫为畏，七滋八味延伸出七十二种变化。 老妈米线正以连锁之势风糜大江南北，将成为您的好邻居和又一温馨可口的家。";
	shop.telephone = @"021-56713017";
	shop.discountInfo  = @"刷卡消费全单9折";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];						
	

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop8.png";
	shop.name = @"卡美奥意大利艺术餐厅";
	shop.address = @"浦东新区碧云路633号";
	shop.altitude	= @"31.265561";
	shop.longitude  = @"121.482162";
	shop.description = @"卡美奥Cameo Ristorante Italiano是一家经营意大利菜的西餐厅，所有食物不含味精、鸡精等添加物，健康美味，低脂肪低热量，是女性的绝佳选择。它位于一座两层楼的独栋黑色大理石现代化楼房内，门前有能容纳50人就餐的露天餐桌，还有充满欧洲风情的灯柱及白色的太阳伞，面对着一个标准足球场大的绿化运动场，面对着绿化景观和欧陆风格的建筑群，让人感觉若置身于欧洲某个城市的生活环境一样。卡美奥Cameo Ristorante Italiano室内的装潢风格以明快的黑白两色为主，还有墙上挂着欧洲现代油画及非常舒适和温暖的柔和灯光。一楼能容纳约40人餐位，而二楼能容纳约60人的餐位。二楼还有一间能容纳10个人的贵宾包房。二楼最适合举办商务晚宴、喜事庆祝聚会或私人宴会，情侣约会等等。";
	shop.telephone = @"021-50302166";
	shop.discountInfo  = @"刷卡消费满300送提拉米苏一份（价值55元）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];						
	

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop7.png";
	shop.name = @"湘间印象概念餐厅";
	shop.address = @"杨浦区国定东路287号";
	shop.altitude	= @"31.239374";
	shop.longitude  = @"121.58284";
	shop.description = @"据说是一家“改良”湘菜馆。菜品配合“本地人口味”，划分了“几级”辣度，性价比“还算高”";
	shop.telephone = @"021-55229617";
	shop.discountInfo  = @"刷卡消费湘菜享受8.8折优惠（茶酒水、海河鲜、燕鲍翅、特价菜除外）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	

	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop6.png";
	shop.name = @"哈尔滨私房菜";
	shop.address = @"黄河路101号";
	shop.altitude	= @"31.297124";
	shop.longitude  = @"121.520531";
	shop.description = @"东北菜菜馆，主要经营各式东北菜肴小吃等。口味正宗，服务也周到。菜肴量大料足，价格也不贵。性价比蛮高，适合朋友聚餐。";
	shop.telephone = @"021-53751738";
	shop.discountInfo  = @"刷卡消费享受8.5折优惠（海鲜、酒水除外，不与其他优惠同时享用）";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	
	
	shop = [[[ShopInfo alloc] init] autorelease];
	shop.imagename = @"shop5.png";
	shop.name = @"美年体检";
	shop.address = @"小木桥路251号";
	shop.altitude	= @"31.3466";
	shop.longitude  = @"121.442184";
	shop.description = @"美年体检依托于国家卫生部下属的中国健康教育协会，是天亿集团实力打造的一家全国性大型连锁的专业体检机构。美年体检联合上海高级医疗专家团队，凭借由国家级专家殷大奎教授领衔的健康管理专家组，先进的医疗设备，温馨舒适的体检环境、国际化水准的健康信息管理平台，先进的安全管理流程控制，以人性的服务理念为客户提供一流的体检及健康管理服务。";
	shop.telephone = @"021-64031199-8049";
	shop.discountInfo  = @"刷卡消费体检套餐和体检单项享受8.8折优惠";
	shop.cardType = @"普卡金卡白金卡";
	[alls addObject: shop];	
	
	NSLog(@"alls %@",[alls description]);
	
	
	NSInteger insertResult = [[DataManager sharedManager] insertShop:alls];
	
	if (insertResult==0) {
		NSLog(@"insert sucessful");
	}else {
		NSLog(@"error");
	}
#endif
	
	/*
	sqlite3 * dbConn = nil;
	
	NSString * path = [[NSBundle mainBundle] pathForResource:@"shops.db" ofType:nil];
	if(sqlite3_open([path UTF8String], & dbConn) != SQLITE_OK) {
		sqlite3_close(dbConn);
		NSLog(@"Error: open database file.");
		return alls;
	}
	
	for (int i=0; i<16; ++i) {
		NSString * str = [NSString stringWithFormat:@"SELECT * FROM shop WHERE key=%d", i/4];
		const char * sql = [str UTF8String];
		
		sqlite3_stmt *statement = nil;
		if (sqlite3_prepare_v2(dbConn, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSLog(@"Error: failed to prepare select table shop.");
			return nil;
		}
		
		// just check the first found item
		if (sqlite3_step(statement) == SQLITE_ROW) {
			ShopInfo * shop = [[[ShopInfo alloc] init] autorelease];
			shop.name = [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)];
			shop.imagename = [NSString stringWithUTF8String:   sqlite3_column_text(statement, 2)];
			shop.address = [NSString stringWithUTF8String:   sqlite3_column_text(statement, 3)];
			shop.altitude	= [NSString stringWithUTF8String:  sqlite3_column_text(statement, 4)];
			shop.longitude  = [NSString stringWithUTF8String:  sqlite3_column_text(statement, 5)];
			shop.description = [NSString stringWithUTF8String:  sqlite3_column_text(statement, 6)];
			shop.telephone = [NSString stringWithUTF8String:  sqlite3_column_text(statement, 7)];
			shop.discountInfo  = [NSString stringWithUTF8String:  sqlite3_column_text(statement, 8)];
			shop.cardType = [NSString stringWithUTF8String:  sqlite3_column_text(statement, 9)];
			[alls addObject: shop];	
		}
		
		sqlite3_finalize(statement);
	}	
	sqlite3_close(dbConn);
	*/
	
	
	return alls;
}

- (void)dealloc {
	//[alls release];
    [super dealloc];
}

@end
