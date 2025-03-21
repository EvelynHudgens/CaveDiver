class_name CaveGeneratorMath

static func CalcMidpoint(p0: CaveGeneratorPoint, p1: CaveGeneratorPoint) -> CaveGeneratorPoint:
	var p: CaveGeneratorPoint = CaveGeneratorPoint.new()
	
	p.x = (p0.x+p1.x)/2
	p.z = (p0.z+p1.z)/2
	
	return p

static func CalcSlope(p0: CaveGeneratorPoint, p1: CaveGeneratorPoint) -> float:
	return -1 * pow((p1.z-p0.z)/(p1.x-p0.x),-1)

static func CalcB(slope: float, mp: CaveGeneratorPoint) -> float:
	return (slope * mp.x - mp.z)/-1

static func CalcDist(p0: CaveGeneratorPoint, p1: CaveGeneratorPoint) -> float:
	return sqrt(pow(p1.x-p0.x, 2) + pow(p1.z-p0.z,2))
	
static func DegToRad(d: float) -> float:
	return d * PI/180
	
static func RadToDeg(r: float) -> float:
	return r * 180/PI
	
static func CalcAngleOfSlope(slope: float) -> float:
	return atan(slope)
	
static func Line(slope: float, b: float, x: float) -> float:
	return slope * x + b

static func CalcOpposite(hyp: float, slope: float) -> float:
	return cos(CaveGeneratorMath.CalcAngleOfSlope(slope)) * hyp
	
static func CalcControlPointX(dist: float, mp: CaveGeneratorPoint, slope: float, concave: int) -> float:
	return mp.x + (concave * (slope/abs(slope))) * CaveGeneratorMath.CalcOpposite(dist, slope)

static func CalcControlPointZ(slope: float, b: float, cp_x: float, concave: int) -> float:
	return CaveGeneratorMath.Line(slope, b, cp_x)
	
static func CalcControlPoint(dist: float, mp: CaveGeneratorPoint, slope: float, b: float, concave: int) -> CaveGeneratorPoint:
	var p: CaveGeneratorPoint = CaveGeneratorPoint.new()
	
	p.x = CaveGeneratorMath.CalcControlPointX(dist, mp, slope, concave)
	p.z = CaveGeneratorMath.CalcControlPointZ(slope, b, p.x, concave)
	
	return p

static func CalcBezierCurveX(t, p0: CaveGeneratorPoint, p1: CaveGeneratorPoint, p2: CaveGeneratorPoint) -> float:
	return pow(1-t,2)*p0.x + 2*t*(1-t)*p1.x + pow(t,2)*p2.x
	
static func CalcBezierCurveZ(t, p0: CaveGeneratorPoint, p1: CaveGeneratorPoint, p2: CaveGeneratorPoint) -> float:
	return pow(1-t,2)*p0.z + 2*t*(1-t)*p1.z + pow(t,2)*p2.z
	
static func CalcBezierCurve(t, p0: CaveGeneratorPoint, p1: CaveGeneratorPoint, p2: CaveGeneratorPoint) -> CaveGeneratorPoint:
	var p: CaveGeneratorPoint = CaveGeneratorPoint.new()
	
	p.x = CaveGeneratorMath.CalcBezierCurveX(t, p0, p1, p2)
	p.z = CaveGeneratorMath.CalcBezierCurveZ(t, p0, p1, p2)
	
	return p
	
static func CalcBezierCurveConversion(v: float, p0: CaveGeneratorPoint, p1: CaveGeneratorPoint) -> float:
	return v/(abs(p1.x-p0.x)) - min(p0.x, p1.x)
	
static func CalcPolygonAngle(n: int) -> float:
	return (n - 2) * (180/n)
