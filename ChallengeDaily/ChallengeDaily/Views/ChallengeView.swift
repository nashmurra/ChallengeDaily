import SwiftUI

struct ChallengeView: View {
    
    var namespace: Namespace.ID
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                Spacer().frame(height: 20)
                
                Text("Daily Challenge")
                    .font(.callout.weight(.semibold))
                    .matchedGeometryEffect(id: "subtitle", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Psychic or Psycho?")
                    .font(.title.weight(.bold))
                    .matchedGeometryEffect(id: "title", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Divider()
                HStack {
                    Spacer()
                    
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .frame(width: 36, height: 26)
                        .cornerRadius(10)
                        .padding(8)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    
                    Text("Idea by Jonathan Krolak")
                        .font(.footnote)
                    
                    Spacer()
                }
                
                Text("Walk up to a stranger and say 'I had a dream about this very moment' and then walk away.")
                    .font(.body)
                    .matchedGeometryEffect(id: "description", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .padding(20)
            .foregroundColor(Color.whiteText)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.backgroundLight)
                    .matchedGeometryEffect(id: "background", in: namespace)
            )
            .mask {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .matchedGeometryEffect(id: "mask", in: namespace)
            }
            .overlay(
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        show.toggle()
                    }
                }) {
                    Image(systemName: "chevron.down.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(red: 115/255, green: 175/255, blue: 239/255))
                }
                    .matchedGeometryEffect(id: "chevron", in: namespace)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 40),
                alignment: .topTrailing
            )
            .padding(.vertical, 20)
        }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        ChallengeView(namespace: namespace, show: .constant(true))
    }
}
