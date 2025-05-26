import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "flutterflow-auth-931d9",
        "private_key_id": "fcf7554c559881d3329007f0c9447c227f9c2185",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC/R7R88IUE8cCf\nTzJGKo2XfjFm0xhjK3xpK1km5lVJaKxksON+qpJYPAI202lAiBlO1H6ED7XYJ89I\nGkGUK8BJsmh0zg0VSaPhibu8WOwuXlgefRdSpPhO/ZJYdIMfz9DeELSuBB9zLH8T\n3jwIBHYo639QDn0fGn3LB+QhMHcqbuk/c/HtutCJ1LEeLPgoN6JKP4dAeBMbvWDx\nVsbTA/vPotmdInWRlRq5+5VEoXSX4/Cg9+SUdKV8BvAWdnV84n0yaxzbF8hW2bqe\nk7gIE9funx56086W1NHUq52Pw4lDesD7dpFQzrMGgj7ZC2OVe8z0rO+55oTeJ1ok\nLSdzKaO/AgMBAAECggEAMHW+pL6cvK1wwwuh7YPfXmeSpX3KmmlMeiqIyiGlrtTt\nhA8Ke69EJ0WAvBogesBgRQfxy4xdYhdn3NkGDz9sVl90Nk9zohaHhd7KqMOQhojR\nY1wGuiHgZMa6Ol2+UKNqQ7BQzhtuSlQWF9cAN3nF48UR+prJGUWxY+wqYDwynJWP\noerOB5t3g9oMo4nyfVwI+cDg19tfMT9gs+lKUNGIP5eacbmNAXEMTtlY+SJi2+V7\n1DrXijo9ONv+c+bnpFLcc+SEbw9kKczOzsN7RUBIwZyud9SpXyaDnUr94qU1hG/a\nUt7m8MkdCXUrj8lTHTH/P/AIpE4PAzi3S/NPBWuYwQKBgQDlFs6H0NDwaas4ZGbQ\nGqSDWATg6szoMoYNbbeomyJTbMR4NtUJzacYn/BfmvN9c2Pwgsa/rUpZtXsfhpat\n1rQvG0bNr4Zyl8O1m21eGD3MycIIJYAWrt65efJ71ae2vSFmzFvCnElPs+0SKtNm\nGaf8C783VFiccDPScaOKuueGfwKBgQDVv+bntn8lrlWbZIYxUJU0dUu3aiYRNOV8\nZj3otPk9Pdf1R84JujMp6+LkpZx7IqzjREnNQX1k+bls4iglSCLWUOpI3t0a+9u0\nlLfwepfuJL3BeFUkNz6iga0cPl3XcuCnGmbodXGCNlsnl9cx3B0jp2dRCqzLOvlz\nUcMZqs/CwQKBgGP+hnul2+10UjY1LONdHb3u54I9Ot+HXhfych34SQ1dBozqcibr\nSypmdYdlnS5+9Xp/urzjqPZrTqi+GHscol2FbGxPV0IhmF1m0GAn+KGw1y6zH6vG\n/JS88+i1o5USDMhQHyVdDmrpwGsTol6IiFht0DMYb+0o1JXg4F+noXOFAoGBAKSy\nTbeijYu6LWojZaaf4ade7a1wk85URLK6kN86eoTunvT2k9I4721QvS3SUaUrTa17\nk6Yc3QKtzGsSQz6eu4EJLcxiNFmzUFFu+d/IhkJPewqUrn3ON2u9oWYOw/3bHTCE\njmB1BbYALfJu87gOU0GCnn/6SrP5R/XMPRkM3TLBAoGBAMU3j6vuKvv4GRvKZWD7\nhXPeLnIG9Ik0pEYmqC+Im1oQP6Q6ALlSJDPm2bKwmd1sxF16RUeQXjfzI6pRSQgC\nPOJP+96YJefff3ZFKtFX97nEkbLguJza5kThoYRpFTMvIY/kT1Nvm62qAdU1iO5f\nJm4GWPgbAvDPAjsRzmomnJ3Y\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-mo7ab@flutterflow-auth-931d9.iam.gserviceaccount.com",
        "client_id": "115872486934617047691",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mo7ab%40flutterflow-auth-931d9.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
