//
//  ChartView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import SwiftUI

struct PriceChartView: View {
    
    let chartData: [String: [Double]]
    
    var body: some View {
        GeometryReader { geometry in
            // 데이터 배열이 있는지 확인
            if let priceData = chartData["price"], !priceData.isEmpty {
                // 그라데이션 배경 영역
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    // 데이터의 최대값과 최소값 찾기
                    let maxValue = priceData.max() ?? 1.0
                    let minValue = priceData.min() ?? 0.0
                    let dataRange = maxValue - minValue
                    
                    // 첫 번째 포인트 좌표 계산
                    let x0 = 0.0
                    let y0 = height * (1.0 - ((priceData[0] - minValue) / dataRange))
                    
                    // 시작점 설정
                    path.move(to: CGPoint(x: x0, y: y0))
                    
                    // 나머지 데이터 포인트로 선 그리기
                    for index in 1..<priceData.count {
                        let x = width * Double(index) / Double(priceData.count - 1)
                        let y = height * (1.0 - ((priceData[index] - minValue) / dataRange))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    // 그라데이션을 위한 닫힌 패스 생성
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.purple.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // 라인만 따로 그리기
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    // 데이터의 최대값과 최소값 찾기
                    let maxValue = priceData.max() ?? 1.0
                    let minValue = priceData.min() ?? 0.0
                    let dataRange = maxValue - minValue
                    
                    // 첫 번째 포인트 좌표 계산
                    let x0 = 0.0
                    let y0 = height * (1.0 - ((priceData[0] - minValue) / dataRange))
                    
                    // 시작점 설정
                    path.move(to: CGPoint(x: x0, y: y0))
                    
                    // 나머지 데이터 포인트로 선 그리기
                    for index in 1..<priceData.count {
                        let x = width * Double(index) / Double(priceData.count - 1)
                        let y = height * (1.0 - ((priceData[index] - minValue) / dataRange))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.purple, lineWidth: 2)
            } else {
                // 데이터가 없을 경우 텍스트 표시
                Text("차트 데이터가 없습니다")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
