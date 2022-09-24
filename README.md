# WTFmod
WTFMod 是怎么一回事？

	它的诞生基于有史以来极其成功且最具竞争力的插件：ZoneMod，是基于ZoneMod 2.X 版本修改而来。
	但是! 这不仅仅是简单的 ZoneMod 变更，它远不止于此，并且将继续与 ZoneMod 一起更新。

WTFMod 目前有什么设定？

	加入狙击等多种装备资源。
	随机刷新资源基本都被移除，会有固定资源补给点。
	以 ZoneMod 为基础且与之类似的地图变化以及其他未在此列出的设置。
	WTFMod 现在的版本为：1.6.2


地图更改：

	Valve 地图中的所有的固定子弹堆、武器生成点和药丸柜生成点被移除。
	开局给所有生还火瓶以及子弹补充包。
	从在zonemod的基础上再清理了一些垃圾道具。
	增加一些近路，某些近路会触发生成坦克。
	在路程中增加一个发光的容器，里面一般是3个针。
	部分地图里会增加不定数量的急救包，位置固定。


游戏玩法/平衡变化

● 分数：

		○ DB 已增加到总血分的50%（zonemod为25%）这意味着 HB 减少到50%。
		○ 药丸的奖励血分提升到 100 。
		○ 总血分倍率有所提升。
		○ 针，医疗包，燃烧弹升级包都不会提供分数。
		○ 全部非救援地图分减少，救援关地图分适当调整。
● 特殊感染者：

		○ 坦克：
			■ 坦克控制权一控为30秒，二控为25秒，未进入控制权之前有60秒的时间。
			■ 坦克对倒地生还的拳头伤害降低为12。
			■ AI坦克会被处死。
			■ 坦克可以在一动不动的情况下呼吸回血，每秒50。（受伤或者走动就会停止）
			■ 坦克可以进行跳砖以及拳砖。
			■ 坦克的石头伤害降低为8。
		○ 女巫：女巫已被移除，不会生成。
		○ 口水：右键扣到生还后会自杀。
			■ 口水点燃汽油的时间为0.75
			■ 每跳伤害为2或3交替，总共伤害为50
		○ 胖子：右键扣到生还后会自杀。（可以炸到生还）
		○ 猎人：猎人右键伤害已降低为 2。
			■ 不能推正在突袭的猎人。
			■ 在2d矢量距离小于500扑中人时，猎人血量回复至满血。
			■ 黑白状态时生还者被高扑会被直接秒杀。（距离需要大于1000）

● 幸存者：

		○ 安全室中将生成固定数量的主武器。
			■ 木喷2把，铁喷1把，uzi1把，mac2把，scout1把。
		○ 右键推猴和舌头的惩罚CD更久。
		○ 移除倒地的视角自动转动。
		○ 移除倒地的扩散惩罚。
		○ 倒地换弹时间加乘削弱到2.0。（默认：1.25）
		○ 倒地射速削弱到0.6秒一发。（默认：0.3秒）
● 增加肾上腺素：

		○ 总回血60，每次回血6点，0.5秒回一次，不会超过总血量。
		○ 救人更快，时间缩短为1秒。（灌油只有小幅度提升）
● 增加医疗包：

		○ 立刻回复99点虚血，2.5秒的使用时间，不会超过总血量。
● 增加火瓶。

		○ 当坦克着火时，会在15秒后熄灭。（大约为1000血量）
● 增加燃烧子弹升级包：

		○ 不会给予燃烧子弹。
		○ 清空你的弹匣。
		○ 给予你主武器的备用子弹
	（scout：120发，喷子：104发，其他：装满

● 武器调整：
	
	○ 近战武器：
		■ 移除了所有可以砍舌头的近战利器。
	
	○ 手枪：
		■ 伤害衰减增加。（rangemod 0.75 >>> 0.72）
		
	○ 沙鹰：
		■ 只会在地图生成一把，伤害提升到100。（默认80）
		■ 现在穿透伤害倍率从30%增加到100%。
		■ 子弹扩散优化。
                           
	○ 加入狙击scout和awp：
		■ 两把枪的弹匣都降低到10发。
		■ 狙击枪 scout 取消移动扩散。
		■ 现在穿透伤害倍率从30%增加到100%。
		■ 狙击打特感头部不论什么距离一枪秒杀  
		
		对特感的其他部位为不同的固定伤害
		例：
		HT的身体（胸部+胃部）		       一枪85伤害
		控住人时的HT身体			一枪200伤害
		猴子的身体				  一枪80伤害
		舌头的身体				  一枪40伤害
		牛的身体/大手臂			距离0-500内：一枪160/200伤害
						      距离超过500时：一枪40/50伤害
		■ 狙击对坦克伤害：
				距离0-500内	一发200伤害
				距离超过500时：
					当坦克速度大于0时	一发40伤害
					当坦克速度等于0时	一发200伤害
