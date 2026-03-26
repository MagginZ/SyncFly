import 'package:flutter/material.dart';

double lerpDouble(double a, double b, double t) => a + (b - a) * t.clamp(0.0, 1.0);

double applyCurve(double t, Curve curve) => curve.transform(t.clamp(0.0, 1.0));
